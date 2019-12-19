//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct CalendarDay {
    
    /// Indicates whether the calendar day is a bank day
    let isBankday: Bool
    
    /// The date of the calendar day.
    let date: Date
    
    /// Week number (1...53)
    let week: Int
    
    /// Year the week belongs to.
    let weekYear: Int

    public init(isBankday: Bool, date: Date, week: Int, weekYear: Int) {
        self.isBankday = isBankday
        self.date = date
        self.week = week
        self.weekYear = weekYear
    }
    
    internal init(node: XMLNode) throws {
        guard node.localName == "return" else {
            throw RiksbankServiceError.invalidData
        }
        guard let dateString = node.valueOfChild(named: "caldate"),
            let date = dateFormatter.date(from: dateString),
            let weekString = node.valueOfChild(named: "week"),
            let week = Int(weekString),
            let weekYearString = node.valueOfChild(named: "weekyear"),
            let weekYear = Int(weekYearString) else {
            throw RiksbankServiceError.invalidData
        }
        self.isBankday = node.valueOfChild(named: "bankday") == "Y"
        self.date = date
        self.week = week
        self.weekYear = weekYear
    }
}
