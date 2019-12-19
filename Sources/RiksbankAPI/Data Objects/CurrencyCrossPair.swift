//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct CurrencyCrossPair {
    public let seriesID1: String
    public let seriesID2: String
    
    public init(seriesID1: String, seriesID2: String) {
        self.seriesID1 = seriesID1
        self.seriesID2 = seriesID2
    }
}
