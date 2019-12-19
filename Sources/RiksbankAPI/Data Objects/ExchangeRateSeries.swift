//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct ExchangeRateSeries: Identifiable {
    public let id: String
    public let name: String
    public let description: String

    public init(id: String, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
    
    internal init(node: XMLNode) throws {
        guard node.localName == "return" else {
            throw RiksbankServiceError.invalidData
        }
        guard let id = node.valueOfChild(named: "seriesid"),
            let name = node.valueOfChild(named: "seriesname"),
            let description = node.valueOfChild(named: "seriesdescription") else {
            throw RiksbankServiceError.invalidData
        }
        self.id = id
        self.name = name
        self.description = description
    }
}
