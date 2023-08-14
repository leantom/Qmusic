//
//  WEExtensions+String.swift
//  facepay_v3
//
//  Created by Nguyen Thanh Duc on 22/10/2020.
//

import Foundation
import UIKit

extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert<S: StringProtocol>(separator: S, from start: Int, every n: Int) {
        var distance = count
        for index in indices.dropFirst(start).reversed() {
            distance -= 1
            guard distance % n == start && index != startIndex else { continue }
            insert(contentsOf: separator, at: index)
        }
    }
}

extension String {
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return stringData.sha256()
        }
        return ""
    }
  
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height + 6)
    }
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
    var folded: String {
        return self.folding(options: .diacriticInsensitive, locale: nil)
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "D")
    }
    
    func applyPatternPhoneNumbers(pattern: String) -> String {
        
        let replacementCharacter: Character = "#"
        
        var pureNumber = self.replacingOccurrences( of: "[^0-9.]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    func hidenCharacterForString(start: Int, end: Int, toString: String) -> String{
        var txt = self
        let rs = txt.index(txt.startIndex, offsetBy: start)
        let re = txt.index(txt.startIndex, offsetBy: end)
        txt.replaceSubrange(rs...re, with: toString)
        return txt
    }
    
    func hiddenNationalId() -> String {
        let startIndex = 2
        var endIndex = 8
        
        if self.count == 9{
            endIndex = 7
        }else if self.count == 12{
            endIndex = 10
        }
        
        let prefix = String(self.prefix(startIndex))// 2 số đầu
        let suffix = String(self.suffix(startIndex))// 2 số cuối
        
        // range
        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(self.startIndex, offsetBy: endIndex)
        let range = start..<end
        let mid = self[range]
        let hiddenUserID = mid.replacingOccurrences(of: "[0-9]", with: ".", options: .regularExpression)
        let endString = prefix + hiddenUserID + suffix
        return endString
    }
    
    func hiddenNameImage() -> String {
        let prefix = String(self.prefix(9))// 9 đầu
        let suffix = String(self.suffix(7))// 7 cuối
        
        let endString = prefix + "..." + suffix
        return endString
    }
    
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.locale = Locale(identifier: "en_US")
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
    
    func hashAndBase64() -> String {
        let _nidHash = self.sha256()
        
        guard let _nidBase64 = _nidHash.data(using: .bytesHexLiteral)?.base64EncodedString() else {return ""}
        return _nidBase64
    }
    
}

extension String {
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
              let range = self[startIndex...]
                .range(of: string, options: options) {
            result.append(range)
            startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

extension String {
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
}


extension String {
    /// Expanded encoding
    ///
    /// - bytesHexLiteral: Hex string of bytes
    /// - base64: Base64 string
    enum ExpandedEncoding {
        /// Hex string of bytes
        case bytesHexLiteral
        /// Base64 string
        case base64
    }

    /// Convert to `Data` with expanded encoding
    ///
    /// - Parameter encoding: Expanded encoding
    /// - Returns: data
    func data(using encoding: ExpandedEncoding) -> Data? {
        switch encoding {
        case .bytesHexLiteral:
            guard self.count % 2 == 0 else { return nil }
            var data = Data()
            var byteLiteral = ""
            for (index, character) in self.enumerated() {
                if index % 2 == 0 {
                    byteLiteral = String(character)
                } else {
                    byteLiteral.append(character)
                    guard let byte = UInt8(byteLiteral, radix: 16) else { return nil }
                    data.append(byte)
                }
            }
            return data
        case .base64:
            return Data(base64Encoded: self)
        }
    }
}


extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func toJson() -> [Dictionary<String,Any>]? {
        let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                print(jsonArray) // use the json here
                
                return jsonArray
            } else {
                return nil
            }
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    func toJson() -> Dictionary<String,Any>? {
        let data = self.data(using: .utf8)!
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
            {
                print(json) // use the json here
                
                return json
            } else {
                return nil
            }
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

extension String {
    func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    }
}

extension String {
    func isValidByRegex(regex: String) -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: regex, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension String {
    var forSorting: String {
        let simple = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
        let nonAlphaNumeric = CharacterSet.alphanumerics.inverted
        return simple.components(separatedBy: nonAlphaNumeric).joined(separator: "")
    }
}


extension String {
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
}


extension String {
    func getTotalFormatCurrency(_ secondString: String) -> String{
        let firstDoubleVal = Double(self) ?? 0
        let secondDoubleVal = Double(secondString) ?? 0
        let total = firstDoubleVal + secondDoubleVal
        return total.formatCurrency()
    }
    
    func formatToCurrency() -> String{
        if let doubleVal = Double(self){
            return doubleVal.formatCurrency()
        }
        return ""
    }
    
    func maskAccountNumber() -> String{
        var resultString = ""
        self.enumerated().forEach { (index, character) in
            // Add space every 4 characters
            if index % 4 == 0 && index > 0 {
                resultString += " "
            }
            if index > 3 && index < 12 {
                // Replace the first 12 characters by *
                resultString += "*"
            } else {
                // Add the last 4 characters to your final string
                resultString.append(character)
            }
        }
        return resultString
    }
    
    func formatToAccountNumber() -> String{
        var resultString = ""
        self.enumerated().forEach { (index, character) in
            // Add space every 4 characters
            if index % 4 == 0 && index > 0 {
                resultString += " "
            }
            resultString.append(character)
        }
        return resultString
    }
    
    func formatFromCurrencyToDouble() -> Double? {
        let newStr = self.replacingOccurrences(of: " ₫", with: "").replacingOccurrences(of: ",", with: "")
        return Double(newStr)
    }
    
    func formatFromCurrencyToString() -> String {
        let newStr = self.replacingOccurrences(of: " ₫", with: "").replacingOccurrences(of: ",", with: "")
        return newStr
    }
    
    
    func appDefaultAttributedString(with lineHieght: CGFloat = 1.22) -> NSAttributedString{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHieght
        return NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func trimWhiteCharacter() -> String {
        let components = self.components(separatedBy: " ")
        var newComponents = [String]()
        for component in components   {
            let str = component.replacingOccurrences(of: " ", with: "")
            if str.count > 0 {
                newComponents.append(str)
            }
        }
        return newComponents.joined(separator: " ")
    }
}

extension Collection {
    public func chunk(n: Int) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}

extension String {
    func chunkFormatted(withChunkSize chunkSize: Int = 4,
                        withSeparator separator: Character = " ") -> String {
        return self.filter { $0 != separator }.chunk(n: chunkSize)
            .map{ String($0) }.joined(separator: String(separator))
    }
    
}

extension UILabel {
    func set(html: String) {
        let modifiedFont = String(format:"<span style=\"font-family: 'SVN-Gilroy'; font-size: 14\">%@</span>", html)
        if let htmlData = modifiedFont.data(using: .utf8, allowLossyConversion: true) {
            do {
                let htmlString = try NSMutableAttributedString(data: htmlData,
                                                               options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                                               documentAttributes: nil)
                
                // MARK: TRICK Display html table
                // https://stackoverflow.com/questions/46546994/does-nshtmltextdocumenttype-support-html-table
                htmlString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: NSMakeRange(0, 1))
                
                self.attributedText = htmlString
            } catch let e as NSError {
                print("Couldn't parse \(html): \(e.localizedDescription)")
            }
        }
    }
    
    func bold(texts: [String]) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self.text ?? "")
        
        for text in texts {
            let range = attributedString.mutableString.range(of: text, options:NSString.CompareOptions.caseInsensitive)
            
            if range.location != NSNotFound {
                attributedString.addAttribute(NSAttributedString.Key.font, value: AppFonts.SVN_Gilroy_Bold.withSize(14), range: range)
            }
        }
        
        self.attributedText = attributedString
    }
    
    func underline(texts: [String]) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self.text ?? "")
        
        for text in texts {
            let range = attributedString.mutableString.range(of: text, options:NSString.CompareOptions.caseInsensitive)
            
            if range.location != NSNotFound {
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            }
        }
        
        self.attributedText = attributedString
    }
    
    func url(texts: [String]) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self.text ?? "")
        for text in texts {
            let range = attributedString.mutableString.range(of: text, options:NSString.CompareOptions.caseInsensitive)
            if range.location != NSNotFound {
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.kPrimary!, range: range)
            }
        }
        
        self.attributedText = attributedString
    }
    
    
}


class NSAttributedStringHelper {
    static func createBulletedList(fromStringArray strings: [String], font: UIFont? = nil, isLineBreakForEach: Bool = false) -> NSAttributedString {
        
        let fullAttributedString = NSMutableAttributedString()
        let attributesDictionary: [NSAttributedString.Key: Any]
        
        if font != nil {
            attributesDictionary = [NSAttributedString.Key.font: font!]
        } else {
            attributesDictionary = [NSAttributedString.Key: Any]()
        }
        
        for index in 0..<strings.count {
            let bulletPoint: String = "\u{2022}"
            var formattedString: String = "\(bulletPoint) \(strings[index])"
            
            if isLineBreakForEach{
                formattedString = "\(formattedString)\n\n"
            }else if index < strings.count - 1 {
                formattedString = "\(formattedString)\n"
            }
            
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
            let paragraphStyle = NSAttributedStringHelper.createParagraphAttribute()
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            fullAttributedString.append(attributedString)
        }
        
        return fullAttributedString
    }
    
    private static func createParagraphAttribute() -> NSParagraphStyle {
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [NSTextTab.OptionKey : Any])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        return paragraphStyle
    }
    
    
}

extension String{
    func removeCurrencyFormatter() -> String {
        if self.isEmpty{
            return self
        }
        let removedCurrency = self.replacingOccurrences(of: " ₫", with: "").replacingOccurrences(of: ",", with: "")
        return removedCurrency
    }
}

extension String {
    func firstCharacterUpperCase() -> String? {
        guard !isEmpty else { return nil }
        let lowerCasedString = self.lowercased()
        return lowerCasedString.replacingCharacters(in: lowerCasedString.startIndex...lowerCasedString.startIndex, with: String(lowerCasedString[lowerCasedString.startIndex]).uppercased())
    }
    
    func firstCharacterLowerCase() -> String {
        let first = self.prefix(1).lowercased()
        let other = self.dropFirst()
        return (first + other)
    }
    
}


extension String{
    //--> hh:mm - dd/mm/yyyy "16/07/2022 14:32"
    func formatPaymentSuccessDate() -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let formatterDate = dateformatter.date(from: self){
            dateformatter.dateFormat = "hh:mm - dd/MM/yyyy"
            let convertedDateStr = dateformatter.string(from: formatterDate)
            return convertedDateStr
        }
        return self
    }
}

extension String{
    
    
    func ignoreZeroValue() -> String{
        if !self.isEmpty, self == "0"{
            return ""
        }
        return self
    }
}

extension String{
    /// Check PCTID belongs to BNPL Card
    /**
    - To check whether card belongs to BNPL Card
    - PCTID is equal to  038 or 033, card belongs to BNPL
     */
    func isBNPLCard() -> Bool{
        if self == "038" || self == "033"{
            return true
        }
        return false
    }
}

extension String{
    static var bullet: String {
        return "• "
    }
}


extension NSAttributedString {
    convenience init(stringList: [String], bullet: String = "\u{2022}", indentation: CGFloat = .zero, lineSpacing: CGFloat = .zero, paragraphSpacing: CGFloat = .zero) {
        let paragraphStyle = NSMutableParagraphStyle()
        let tabStopOptions: [NSTextTab.OptionKey: Any] = [:]
        
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: tabStopOptions)
        ]
        
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            let attributedStringRange = NSMakeRange(0, attributedString.length)
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: attributedStringRange)
            
            bulletList.append(attributedString)
        }
        
        self.init(attributedString: bulletList)
    }
}
extension NSDictionary{
    
    func toString() -> String? {
  
            let data = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
    
    }
}

extension String{
    ///
    ///This method is used to insert substring at indexs
    ///
    ///    self --> 24111990, char -> "/", indexs -> [2, 5]
    ///     // Prints 24/11/1990
    ///
    ///
    mutating func insertSubString(char: Character, indexs:[Int]) -> String {
        for index in indexs {
            if self.count <= index{
                continue
            }
            self.insert(char, at: self.index(self.startIndex, offsetBy: index))
        }
        return self
    }
}
