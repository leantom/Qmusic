//
//  WEExtensions+TimerInterval.swift
//  FEMobile
//
//  Created by MrDatto on 6/24/21.
//
import UIKit

extension TimeInterval{
    func showFormatTimerCoundown() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        
        if let formattedDuration = formatter.string(from: self) {
            return formattedDuration
        }
        return nil
    }
    
    func showFormatTimerCoundownHours() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute ]
        formatter.zeroFormattingBehavior = [ .pad ]
        
        if let formattedDuration = formatter.string(from: self) {
            return formattedDuration
        }
        return nil
    }
}
