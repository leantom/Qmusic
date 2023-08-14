//
//  WEExtensions+Calendar.swift
//  FEMobile
//
//  Created by Nguyen Thanh Duc on 17/06/2021.
//

import Foundation

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
            let fromDate = startOfDay(for: from) // <1>
            let toDate = startOfDay(for: to) // <2>
            let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
            
            return numberOfDays.day!
        }
}
