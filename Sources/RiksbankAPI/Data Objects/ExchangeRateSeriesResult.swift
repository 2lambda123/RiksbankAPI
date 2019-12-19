//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct ExchangeRateSeriesResult {
    
    public let seriesID1: String
    public let seriesID2: String
    public let name: String
    public let series: [ExchangeRateResultRow]

    public init(seriesID1: String, seriesID2: String, name: String, series: [ExchangeRateResultRow]) {
        self.seriesID1 = seriesID1
        self.seriesID2 = seriesID2
        self.name = name
        self.series = series
    }
    
    internal init(node: XMLNode) throws {
        guard node.localName == "series" else {
            throw RiksbankServiceError.invalidData
        }
        guard let seriesID1 = node.valueOfChild(named: "seriesid1"),
            let seriesID2 = node.valueOfChild(named: "seriesid2"),
            let name = node.valueOfChild(named: "seriesname") else {
            throw RiksbankServiceError.invalidData
        }
        self.seriesID1 = seriesID1
        self.seriesID2 = seriesID2
        self.name = name
        self.series = try Self.makeSeries(node)
    }
    
    private static func makeSeries(_ node: XMLNode) throws -> [ExchangeRateResultRow] {
        return try (node.children ?? []).filter {
            $0.localName == "resultrows"
        }.map {
            try ExchangeRateResultRow(node: $0)
        }
    }
}
