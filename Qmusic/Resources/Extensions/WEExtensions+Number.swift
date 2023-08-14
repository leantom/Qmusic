//
//  WEExtensions+Number.swift
//  FEMobile
//
//  Created by quang on 10/08/2021.
//

import Foundation
extension Float {
    func formatCurrency() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        guard let strFormat = numberFormatter.string(from: self as NSNumber) else {
            return ""
        }
        return strFormat + " ₫"
    }
    
    func formatCurrencyNotHasSuffix() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        guard let strFormat = numberFormatter.string(from: self as NSNumber) else {
            return ""
        }
        return strFormat
    }
}
extension Int {
    
    func formatCurrencyWithHasPayment() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        guard let strFormat = numberFormatter.string(from: self as NSNumber) else {
            return ""
        }
        return "-" + strFormat + " ₫"
    }
    
    func formatCurrencyForOiRewards() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        guard let strFormat = numberFormatter.string(from: self as NSNumber) else {
            return ""
        }
        return strFormat + " điểm"
    }
    
    func formatCurrency() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        guard let strFormat = numberFormatter.string(from: self as NSNumber) else {
            return ""
        }
        return strFormat + " ₫"
    }
    
    func formatCurrencyNotHasSuffix() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        guard let strFormat = numberFormatter.string(from: self as NSNumber) else {
            return ""
        }
        return strFormat
    }
    
}

extension Int64 {
    func formatCurrencyNotHasSuffix() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        guard let strFormat = numberFormatter.string(from: self as NSNumber) else {
            return ""
        }
        return strFormat
    }
    
    func formatCurrency() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        guard let strFormat = numberFormatter.string(from: self as NSNumber) else {
            return ""
        }
        return strFormat + " ₫"
    }
}

extension Double {
    func formatCurrency() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        guard let strFormat = numberFormatter.string(from: self as NSNumber) else {
            return ""
        }
        return strFormat + " ₫"
    }
}
extension Int {
	
	func toCurrency(_ code: String? = nil) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.currencyGroupingSeparator = ","
		formatter.locale = Locale(identifier: "vi_VN")
		formatter.currencyCode = "VND"

		if code != nil {
			formatter.currencySymbol = code
		}

		return formatter.string(from: NSNumber(value: self)) ?? ""
	}

	private static var commaFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal

		return formatter
	}()

	internal var commaRepresentation: String {
		return Int.commaFormatter.string(from: NSNumber(value: self)) ?? ""
	}

}

extension Double {
	
	func toCurrency(_ code: String? = nil) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.currencyGroupingSeparator = ","
		formatter.locale = Locale(identifier: "vi_VN")
		formatter.currencyCode = "VND"

		if code != nil {
			formatter.currencySymbol = code
		}

		return formatter.string(from: NSNumber(value: self)) ?? ""
	}
}
