//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct AllCrossNamesResponse {
    public let language: RiksbankService.Language
    public let crossNames: [ExchangeRateSeries]
    
    public init(language: RiksbankService.Language, crossNames: [ExchangeRateSeries]) {
        self.language = language
        self.crossNames = crossNames
    }
    
    internal init(language: RiksbankService.Language, node: XMLNode) throws {
        self.language = language
        guard node.localName == "getAllCrossNamesResponse" else {
            throw RiksbankServiceError.invalidData
        }
        crossNames = try node.children?
            .filter({ $0.localName == "return" })
            .compactMap { try ExchangeRateSeries(node: $0) }
            ?? []
    }
}
