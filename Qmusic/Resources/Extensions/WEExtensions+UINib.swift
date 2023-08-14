//
//  WEExtensions+UINib.swift
//  facepay_v3
//
//  Created by Nguyen Thanh Duc on 20/10/2020.
//

import Foundation
import UIKit

extension UINib {
    func instantiate() -> Any? {
        return self.instantiate(withOwner: nil, options: nil).first
    }
}

extension UIDevice {
    func getOSInfo() -> String {
        let os = ProcessInfo.processInfo.operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
}
