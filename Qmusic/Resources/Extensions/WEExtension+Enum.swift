//
//  WEExtension+Enum.swift
//  FEMobile
//
//  Created by APPLE on 19/01/22.
//

import Foundation
import UIKit

extension CaseIterable where Self: Equatable {
    var allCases: AllCases { Self.allCases }

    /// Using `next` on an empty enum of on the last element returns `nil`
    var next: Self? {
        guard let currentIndex = allCases.firstIndex(of: self) else { return nil }

        let index = allCases.index(after: currentIndex)

        // ensure we don't go past the last element
        guard index != allCases.endIndex else { return nil }
        return allCases[index]
    }

    var previous: Self? {
        guard let currentIndex = allCases.firstIndex(of: self) else { return nil }

        // ensure we don't go before the first element
        
        guard currentIndex != allCases.startIndex else { return nil }
        let index = allCases.index(currentIndex, offsetBy: -1)

        return allCases[index]
    }
}
