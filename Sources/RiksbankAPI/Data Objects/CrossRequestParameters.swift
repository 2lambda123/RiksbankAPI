//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

//<crossRequestParameters>
//    <aggregateMethod>D</aggregateMethod>
//    <!--1 or more repetitions:-->
//    <crossPair>
//        <seriesid1>SEKNOKPMI</seriesid1>
//        <seriesid2>SEK</seriesid2>
//    </crossPair>
//    <datefrom>2011-01-01</datefrom>
//    <dateto>2011-03-01</dateto>
//    <languageid>en</languageid>
//</crossRequestParameters>

public struct CrossRequestParameters {
    
    public enum AggregateMethod {
        case daily
        case weekly
        case monthly
        case quarterly
        case yearly
        
        var value: String {
            switch self {
            case .daily: return "D"
            case .weekly: return "W"
            case .monthly: return "M"
            case .quarterly: return "Q"
            case .yearly: return "Y"
            }
        }
    }
    
    public let aggregateMethod: AggregateMethod
    
    public let crossPairs: [CurrencyCrossPair]
    
    public let interval: ClosedRange<Date>
    
    public let language: RiksbankService.Language
    
    public init(aggregateMethod: AggregateMethod,
                crossPairs: [CurrencyCrossPair],
                interval: ClosedRange<Date>,
                language: RiksbankService.Language) {
        self.aggregateMethod = aggregateMethod
        self.crossPairs = crossPairs
        self.interval = interval
        self.language = language
    }
    
    public func makeXML() -> String {
        var xml = """
        <crossRequestParameters>
            <aggregateMethod>\(aggregateMethod.value)</aggregateMethod>
        """
        for pair in crossPairs {
            xml.append("""
            <crossPair>
                <seriesid1>\(pair.seriesID1)</seriesid1>
                <seriesid2>\(pair.seriesID2)</seriesid2>
            </crossPair>
            """)
        }
        xml.append("""
            <datefrom>\(dateFormatter.string(from: interval.lowerBound))</datefrom>
            <dateto>\(dateFormatter.string(from: interval.upperBound))</dateto>
            <languageid>\(language.id)</languageid>
        </crossRequestParameters>
        """)
        return xml
    }
}
