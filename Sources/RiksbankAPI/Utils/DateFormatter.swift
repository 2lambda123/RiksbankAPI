//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

internal let dateFormatter: DateFormatter = {
    $0.dateFormat = "yyyy-MM-dd"
    return $0
}(DateFormatter())
