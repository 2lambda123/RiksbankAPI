//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct CrossRatesResponse {
    public let aggregateMethod: CrossRequestParameters.AggregateMethod
    public let language: RiksbankService.Language
    public let results: [CrossRateResult]
    
    public init(aggregateMethod: CrossRequestParameters.AggregateMethod,
                language: RiksbankService.Language,
                results: [CrossRateResult]) {
        self.aggregateMethod = aggregateMethod
        self.language = language
        self.results = results
    }
    
    internal init(aggregateMethod: CrossRequestParameters.AggregateMethod,
                  language: RiksbankService.Language,
                  node: XMLNode) throws {
        self.aggregateMethod = aggregateMethod
        self.language = language
        guard node.localName == "getCrossRatesResponse" else {
            throw RiksbankServiceError.invalidData
        }
        results = try node.children?
            .filter({ $0.localName == "return" })
            .compactMap { try CrossRateResult(node: $0) }
            ?? []
    }
}
