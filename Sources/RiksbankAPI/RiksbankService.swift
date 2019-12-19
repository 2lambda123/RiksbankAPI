//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import Combine

public enum RiksbankServiceError: LocalizedError {
    case httpStatusCode(Int)
    case invalidData

    public var errorDescription: String? {
        switch self {
        case .httpStatusCode(let statusCode):
            return "HTTP request failed with status code \(statusCode)."
        case .invalidData:
            return "The data is invalid."
        }
    }
}

public class RiksbankService {
    
    public static let wsdlURL = URL(validString: "https://swea.riksbank.se/sweaWS/wsdl/sweaWS_ssl.wsdl")
    
    public static let serviceURL = URL(validString: "https://swea.riksbank.se:443/sweaWS/services/SweaWebServiceHttpSoap12Endpoint")

    public enum Language: String, Identifiable {
        case english = "en"
        case swedish = "sv"
        
        public var id: String { rawValue }
    }
        
    public init() {
        //
    }
    
    public func calendarDays(interval: ClosedRange<Date>) -> AnyPublisher<CalendarDaysResponse, Error> {
        let message = """
        <xsd:getCalendarDays>
            <datefrom>\(dateFormatter.string(from: interval.lowerBound))</datefrom>
            <dateto>\(dateFormatter.string(from: interval.upperBound))</dateto>
        </xsd:getCalendarDays>
        """
        return performSOAP(action: "getCalendarDays", message: message)
            .tryMap {
                let path = ["Envelope", "Body", "getCalendarDaysResponse"]
                guard let node = try XMLDocument(data: $0, options: []).node(at: path) else {
                    throw RiksbankServiceError.invalidData
                }
                return try CalendarDaysResponse(interval: interval, node: node)
            }
            .eraseToAnyPublisher()
    }
    
    public func allCrossNames(language: Language) -> AnyPublisher<AllCrossNamesResponse, Error> {
        let message = """
        <xsd:getAllCrossNames>
            <languageid>\(language.id)</languageid>
        </xsd:getAllCrossNames>
        """
        return performSOAP(action: "getAllCrossNames", message: message)
            .tryMap {
                let path = ["Envelope", "Body", "getAllCrossNamesResponse"]
                guard let node = try XMLDocument(data: $0, options: []).node(at: path) else {
                    throw RiksbankServiceError.invalidData
                }
                return try AllCrossNamesResponse(language: language, node: node)
            }
            .eraseToAnyPublisher()
    }
    
    public func crossRates(aggregateMethod: CrossRequestParameters.AggregateMethod,
                          crossPairs: [CurrencyCrossPair],
                          interval: ClosedRange<Date>,
                          language: Language) -> AnyPublisher<CrossRatesResponse, Error> {
        let parameters = CrossRequestParameters(aggregateMethod: aggregateMethod,
                                                crossPairs: crossPairs,
                                                interval: interval,
                                                language: language)
        let message = """
        <xsd:getCrossRates>
        \(parameters.makeXML())
        </xsd:getCrossRates>
        """
        return performSOAP(action: "getCrossRates", message: message)
            .tryMap {
                let path = ["Envelope", "Body", "getCrossRatesResponse"]
                guard let node = try XMLDocument(data: $0, options: []).node(at: path) else {
                    throw RiksbankServiceError.invalidData
                }
                return try CrossRatesResponse(aggregateMethod: aggregateMethod, language: language, node: node)
            }
            .eraseToAnyPublisher()
    }
}

private extension RiksbankService {
    private func performSOAP(action: String, message: String) -> AnyPublisher<Data, Error> {
        
        let soapMessage = """
        <?xml version="1.0" encoding="UTF-8"?>
        <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsd="http://swea.riksbank.se/xsd">
            <soap:Header/>
            <soap:Body>
                \(message)
            </soap:Body>
        </soap:Envelope>
        """

        
        var urlRequest = URLRequest(url: Self.serviceURL,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 60)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/soap+xml", forHTTPHeaderField: "Accept")
        urlRequest.setValue("text/xml; charset=utf-8; action=\"urn:\(action)\"", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("\"urn:\(action)\"", forHTTPHeaderField: "SOAPAction")
        urlRequest.httpBody = soapMessage.data(using: .utf8)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                if let response = response as? HTTPURLResponse {
                    guard 200...299 ~= response.statusCode else {
                        throw RiksbankServiceError.httpStatusCode(response.statusCode)
                    }
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}
