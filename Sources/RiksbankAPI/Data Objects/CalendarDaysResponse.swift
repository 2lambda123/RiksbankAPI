//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct CalendarDaysResponse {

    public let interval: ClosedRange<Date>
    public let days: [CalendarDay]
    
    public init(interval: ClosedRange<Date>, days: [CalendarDay]) {
        self.interval = interval
        self.days = days
    }
    
    internal init(interval: ClosedRange<Date>, node: XMLNode) throws {
        self.interval = interval
        guard node.localName == "getCalendarDaysResponse" else {
            throw RiksbankServiceError.invalidData
        }
        days = try node.children?
            .filter({ $0.localName == "return" })
            .compactMap { try CalendarDay(node: $0) }
            ?? []
    }
}
