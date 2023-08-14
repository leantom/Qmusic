//
//  WEExtensions+Double.swift
//  FEMobile
//
//  Created by Nguyen Thanh Duc on 14/08/2021.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        let _temp = self * divisor
        return _temp.rounded() / divisor
    }
}

