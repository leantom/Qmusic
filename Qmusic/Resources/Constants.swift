//
//  Constants.swift
//  facepay_v3
//
//  Created by Nguyen Thanh Duc on 23/10/2020.
//

import Foundation
import UIKit

class Constants {
    static let Width: CGFloat = UIScreen.main.bounds.size.width
    static let Height: CGFloat = UIScreen.main.bounds.size.height
    
    static let color_Black_60             = UIColor(named: "Black-60") ?? UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
    static let color_Black_B100           = UIColor(named: "Black-B100") ?? UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0)
    static let color_FEGradient_Primary_1 = UIColor(named: "FEGradient-Primary-1") ?? UIColor(red: 112/255, green: 181/255, blue: 87/255, alpha: 1.0)
    static let color_FEGradient_Primary_2 = UIColor(named: "FEGradient-Primary-2") ?? UIColor(red: 14/255, green: 142/255, blue: 81/255, alpha: 1.0)
    static let color_Gray_50              = UIColor(named: "Gray-50") ?? UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1.0)
    static let color_Green_40             = UIColor(named: "Green-40") ?? UIColor(red: 187/255, green: 215/255, blue: 189/255, alpha: 1.0)
    static let color_Green_100            = UIColor(named: "Green-100") ?? UIColor(red: 86/255, green: 156/255, blue: 89/255, alpha: 1.0)
    static let color_Light_Green          = UIColor(named: "Light Green") ?? UIColor(red: 238/255, green: 255/255, blue: 234/255, alpha: 1.0)
    static let color_Pure                 = UIColor(named: "Pure") ?? UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
    static let color_Gray_G30             = UIColor(named: "Gray-G30") ?? UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
    
    static let maximumPhotoSize = 5 * 1024 * 1024
}

class ConstantsUI {
    static let ratioScreen:CGFloat = UIScreen.main.bounds.height/812
    static let backgroundAlphaForPopup:CGFloat = 0.7
    static let minximumHistoryTransaction:CGFloat = 50
    static let heightFieldForm: CGFloat = 90
    static let heightFieldFormInputPreview: CGFloat = 120
    static let timeOTPInvalid: CGFloat = 180
    static let heightFieldPendingEsign: CGFloat = 30
    static let widthScreen = UIScreen.main.bounds.width
    static let heightScreen = UIScreen.main.bounds.height
    static let selectPromoHeight = CGFloat(293)
}
