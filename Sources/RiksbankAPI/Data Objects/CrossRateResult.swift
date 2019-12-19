//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct CrossRateResult {
    
    public let interval: ClosedRange<Date>
    public let informationText: String
    public let groups: [CrossRateResultGroup]

    public init(interval: ClosedRange<Date>, informationText: String, groups: [CrossRateResultGroup]) {
        self.interval = interval
        self.informationText = informationText
        self.groups = groups
    }
    
    internal init(node: XMLNode) throws {
        guard node.localName == "return" else {
            throw RiksbankServiceError.invalidData
        }
        guard let fromString = node.valueOfChild(named: "datefrom"),
            let from = dateFormatter.date(from: fromString),
            let toString = node.valueOfChild(named: "dateto"),
            let to = dateFormatter.date(from: toString),
            let informationText = node.valueOfChild(named: "informationtext") else {
            throw RiksbankServiceError.invalidData
        }
        self.interval = from...to
        self.informationText = informationText
        self.groups = try Self.makeGroups(node)
    }
    
    private static func makeGroups(_ node: XMLNode) throws -> [CrossRateResultGroup] {
        return try (node.children ?? []).filter {
            $0.localName == "groups"
        }.map {
            try CrossRateResultGroup(node: $0)
        }
    }
}
