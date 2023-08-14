//
//  AppFonts.swift
//  facepay_v3
//
//  Created by Nguyen Thanh Duc on 12/10/2020.
//

import UIKit

enum AppFonts: String {
    //SVN - Medium
    //SVN - Italic
    //SVN - Bold
    //SVN - Regular
    //SVN - SemiBold
    case SVN_Gilroy_Regular = "SVN-Gilroy"
    case SVN_Gilroy_SemiBold = "SVN-GilroySemiBold"
    case SVN_Gilroy_Bold = "SVN-GilroyBold"
    case SVN_Gilroy_Italic = "SVN-Gilroy-Italic"
    case SVN_Gilroy_Medium = "SVN-Gilroy-Medium"
    case OCR_A_STD_REGULAR = "OCR-A-Std-Regular"
    //BebasNeue-Regular
//    case BebasNeue_Regular = "Bebas-Regular"
//    case BebasNeue_Bold = "Bebas-Bold"
//    case BebasNeue_Light = "Bebas-Light"
//    case BebasNeue_Thin = "Bebas-Thin"
    
    //Roboto - Italic
//    case Roboto_Italic = "Roboto-Italic"
    
    //OCR
    case OCR_A_Regular = "OcrA-Regular"
    case OCR_A = "Ocr-A"

}

extension AppFonts {
    func withSize(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    func withDefaultSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
}


extension UIFont {
    static func kBold(ofSize: CGFloat) -> UIFont {
        UIFont.init(name: "SVN-GilroyBold", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: .bold)
    }
    static func kItalic(ofSize: CGFloat) -> UIFont {
        UIFont.init(name: "SVN-GilroyItalic", size: ofSize) ?? UIFont.italicSystemFont(ofSize: ofSize)
    }
    static func kMedium(ofSize: CGFloat) -> UIFont {
        UIFont.init(name: "SVN-GilroyMedium", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: .medium)
    }
    static func kRegular(ofSize: CGFloat) -> UIFont {
        UIFont.init(name: "SVN-Gilroy", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: .regular)
    }
    static func kSemiBold(ofSize: CGFloat) -> UIFont {
        UIFont.init(name: "SVN-GilroySemiBold", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: .semibold)
    }
}
