//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct CrossRateResultGroup: Identifiable {
    
    public let id: String
    public let name: String
    public let series: [ExchangeRateSeriesResult]

    public init(id: String, name: String, series: [ExchangeRateSeriesResult]) {
        self.id = id
        self.name = name
        self.series = series
    }
    
    internal init(node: XMLNode) throws {
        guard node.localName == "groups" else {
            throw RiksbankServiceError.invalidData
        }
        guard let id = node.valueOfChild(named: "groupid"),
            let name = node.valueOfChild(named: "groupname") else {
            throw RiksbankServiceError.invalidData
        }
        self.id = id
        self.name = name
        self.series = try Self.makeSeries(node)
    }
    
    private static func makeSeries(_ node: XMLNode) throws -> [ExchangeRateSeriesResult] {
        return try (node.children ?? []).filter {
            $0.localName == "series"
        }.map {
            try ExchangeRateSeriesResult(node: $0)
        }
    }
}
