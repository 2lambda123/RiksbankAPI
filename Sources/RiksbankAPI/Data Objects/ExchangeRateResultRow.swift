//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct ExchangeRateResultRow {
    
    /// Date of the observation value when Daily aggregate method is selected.
    /// Otherwise first date of period
    public let date: Date
    
    /// Name of period for non-daily aggregate. e.g 2011 Week 41, 2012 January
    public let period: String
    
    /// The minimum value for the period, when weekly, monthly, quarterly, or
    /// annual minimum aggregate method is selected.
    /// Null (nil=true for daily aggregates). Not valid for CrossResults.
    public let min: Double?
    
    /// The average value for the period, when weekly, monthly, quarterly,
    /// or annual average is selected.
    /// Null (nil=true for daily aggregates).
    public let average: Double?
    
    /// The maximum value for the period, when weekly, monthly, quarterly,
    /// or annual maximum aggregate method is selected.
    /// Null (nil=true for daily aggregates). Not valid for CrossResults
    public let max: Double?
    
    /// The final listing for the month, when ultimo aggregate method is
    /// selected.
    /// Null (nil=true for daily aggregates). Not valid for CrossResults
    public let ultimo: Double?
    
    /// Value of observation, when daily aggregate methos is selected.
    /// Null (nil=true for non-daily aggregates).
    public let value: Double?

    public init(date: Date,
                period: String,
                min: Double,
                average: Double,
                max: Double,
                ultimo: Double,
                value: Double) {
        self.date = date
        self.period = period
        self.min = min
        self.average = average
        self.max = max
        self.ultimo = ultimo
        self.value = value
    }
    
    internal init(node: XMLNode) throws {
        guard node.localName == "resultrows" else {
            throw RiksbankServiceError.invalidData
        }
        guard let dateString = node.valueOfChild(named: "date"),
            let date = dateFormatter.date(from: dateString),
            let period = node.valueOfChild(named: "period") else {
            throw RiksbankServiceError.invalidData
        }
        self.date = date
        self.period = period
        self.min = node.valueOfChild(named: "min").flatMap(Double.init)
        self.average = node.valueOfChild(named: "average").flatMap(Double.init)
        self.max = node.valueOfChild(named: "max").flatMap(Double.init)
        self.ultimo = node.valueOfChild(named: "ultimo").flatMap(Double.init)
        self.value = node.valueOfChild(named: "value").flatMap(Double.init)
    }
}
