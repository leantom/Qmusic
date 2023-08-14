//
//  WEExtensions+UILabel.swift
//  facepay_v3
//
//  Created by LV on 10/26/20.
//

import Foundation
import UIKit

extension UILabel {
    
    func colorDate(withFormat format: String, color: UIColor) {
        guard let text = self.text else { return }
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
            let matches = detector.matches(in: text, range: NSMakeRange(0, text.count))
            let formatter = DateFormatter()
            for match in matches {
                if match.resultType == .date {
                    guard let date = match.date else {
                        continue
                    }
                    formatter.dateFormat = format
                    let stringDate = formatter.string(from: date)
                    
                    let range = attributedString.mutableString.range(of: stringDate, options:NSString.CompareOptions.caseInsensitive)
                    
                    if range.location != NSNotFound {
                        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
                        attributedString.addAttribute(NSAttributedString.Key.font, value: AppFonts.SVN_Gilroy_Bold.withSize(14), range: range)
                    }
                }
            }
            self.attributedText = attributedString
        } catch {
            print(error)
            return
        }
    }
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            
            attributedText = attributedString
        }
        
        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
    
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attrString = NSMutableAttributedString()
        if (self.attributedText != nil) {
            attrString.append( self.attributedText!)
        } else {
            attrString.append( NSMutableAttributedString(string: self.text!))
            attrString.addAttribute(NSAttributedString.Key.font, value: self.font!, range: NSMakeRange(0, attrString.length))
        }
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
    
    func setOnlyTitleStyle(){
        self.font = AppFonts.SVN_Gilroy_Regular.withSize(14)
        self.textColor = AppColors.k191919
        self.setLineHeight(lineHeight: 1.22)
    }
    
    func setTitleWithDetailStyle(){
        self.numberOfLines = 0
        self.font = AppFonts.SVN_Gilroy_Regular.withSize(12)
        self.textColor = AppColors.k757575
        self.setLineHeight(lineHeight: 1.11)
    }
}

extension UILabel {
    func setDiffColor(color: UIColor, range: NSRange) {
        let attText = NSMutableAttributedString(string: self.text!)
        attText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attributedText = attText
    }
    
    func setDiffColor(color: UIColor, subString: String) {
        let attributedString: NSMutableAttributedString = self.attributedText != nil ? NSMutableAttributedString(attributedString: self.attributedText!) : NSMutableAttributedString(string: self.text!)
        
        let range = attributedString.mutableString.range(of: subString, options:NSString.CompareOptions.caseInsensitive)
        
        if range.location != NSNotFound {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        self.attributedText = attributedString
    }
    
    func setSubTextColor(pSubString : String, pColor : UIColor) {
        let attributedString: NSMutableAttributedString = self.attributedText != nil ? NSMutableAttributedString(attributedString: self.attributedText!) : NSMutableAttributedString(string: self.text!);
        
        
        let range = attributedString.mutableString.range(of: pSubString, options:NSString.CompareOptions.caseInsensitive)
        if range.location != NSNotFound {
            
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: pColor, range: range)
        }
        self.attributedText = attributedString
    }
    
    func setFontArrText(pSubString: String, font: UIFont) {
        if let text = self.text{
            let attributedString = NSMutableAttributedString(string: text)
            text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .byWords) {
                (substring, substringRange, _, _) in
                if substring == pSubString {
                    attributedString.setAttributes([NSAttributedString.Key.font : font], range: NSRange(substringRange, in: text))
                }
            }
            self.attributedText = attributedString
        }
    }
}

extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
//    override open func draw(_ rect: CGRect) {
//        if let insets = padding {
//            self.drawText(in: rect.inset(by: insets))
//        } else {
//            self.drawText(in: rect)
//        }
//    }
}

extension UILabel {
    
    func setDiffFontandColorwith(pSubString: String, font: UIFont, color: UIColor){
        let attributedString: NSMutableAttributedString = self.attributedText != nil ? NSMutableAttributedString(attributedString: self.attributedText!) : NSMutableAttributedString(string: self.text!);
        let range = attributedString.mutableString.range(of: pSubString, options:NSString.CompareOptions.caseInsensitive)
        if range.location != NSNotFound {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range);
        }
        self.attributedText = attributedString
    }
    
    
    func applyGradientWith(startColor: UIColor, endColor: UIColor) {
        
        var startColorRed:CGFloat = 0
        var startColorGreen:CGFloat = 0
        var startColorBlue:CGFloat = 0
        var startAlpha:CGFloat = 0
        
        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return
        }
        
        var endColorRed:CGFloat = 0
        var endColorGreen:CGFloat = 0
        var endColorBlue:CGFloat = 0
        var endAlpha:CGFloat = 0
        
        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return
        }
        
        let gradientText = self.text ?? ""
        
        let textSize: CGSize = gradientText.size(withAttributes: [NSAttributedString.Key.font:self.font!])
        let width:CGFloat = textSize.width
        let height:CGFloat = textSize.height
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        UIGraphicsPushContext(context)
        
        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        let components:[CGFloat] = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        let topCenter = CGPoint.zero
        let bottomCenter = CGPoint(x: 0, y: textSize.height)
        context.drawLinearGradient(glossGradient!, start: topCenter, end: bottomCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        UIGraphicsPopContext()
        
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        UIGraphicsEndImageContext()
        self.textColor = UIColor(patternImage: gradientImage)
    }
}

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0,
                        lineHeightMultiple: CGFloat = 0.0,
                        align: NSTextAlignment?) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        if let align = align {
            paragraphStyle.alignment = align
        }
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        
        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    func highlight(searchText: String, color: UIColor = .yellow) {
        guard let labelText = self.text else { return }
        do {
            let mutableString = NSMutableAttributedString(string: labelText)
            let regex = try NSRegularExpression(pattern: searchText, options: .caseInsensitive)
            
            for match in regex.matches(in: labelText, options: .withTransparentBounds, range: NSRange(location: 0, length: labelText.utf16.count)) as [NSTextCheckingResult] {
                mutableString.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: match.range)
            }
            self.attributedText = mutableString
        } catch {
            print(error)
        }
    }

    func highlight(searchText: String, font: UIFont) {
        guard let labelText = self.text else { return }
        do {
            let mutableString = NSMutableAttributedString(string: labelText)
            let regex = try NSRegularExpression(pattern: searchText, options: .caseInsensitive)
            
            for match in regex.matches(in: labelText, options: .withTransparentBounds, range: NSRange(location: 0, length: labelText.utf16.count)) as [NSTextCheckingResult] {
                mutableString.addAttribute(NSAttributedString.Key.font, value: font, range: match.range)
            }
            self.attributedText = mutableString
        } catch {
            print(error)
        }
    }
    
    func setFontText(pSubString: String, font: UIFont) {
        let attributedString: NSMutableAttributedString = self.attributedText != nil ? NSMutableAttributedString(attributedString: self.attributedText!) : NSMutableAttributedString(string: self.text!);
        let range = attributedString.mutableString.range(of: pSubString, options:NSString.CompareOptions.caseInsensitive)
        if range.location != NSNotFound {
            attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range);
        }
        self.attributedText = attributedString
    }
    
    func setText(value: String?, highlight: String?) {
        
        guard let value = value, let highlight = highlight else { return }
        
        let _value = value.folded
        let _highlight = highlight.folded
        let attributedText = NSMutableAttributedString(string: value)
        let range = (_value as NSString).range(of: _highlight, options: .caseInsensitive)
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .backgroundColor: AppColors.k757575!,
            .foregroundColor: UIColor.black
        ]
        
        attributedText.addAttributes(strokeTextAttributes, range: range)
        self.attributedText = attributedText
    }
}


extension UILabel{
    func setUnderline(){
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: self.text ?? "", attributes: underlineAttribute)
        self.attributedText = underlineAttributedString
    }
    
    func addTextWithImage(text: String, image: UIImage, imageBehindText: Bool, keepPreviousText: Bool) {
        let lAttachment = NSTextAttachment()
        lAttachment.image = image
        
        // 1pt = 1.32px
        let lFontSize = round(self.font.pointSize * 1.32)
        let _ = image.size.width / image.size.height
        
        lAttachment.bounds = CGRect(x: 0, y: ((self.font.capHeight - lFontSize) / 2).rounded(), width: 18, height: 18)
        
        let lAttachmentString = NSAttributedString(attachment: lAttachment)
        
        if imageBehindText {
            let lStrLabelText: NSMutableAttributedString
            
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(string: text + " ")
            }
            
            lStrLabelText.append(lAttachmentString)
            self.attributedText = lStrLabelText
        } else {
            let lStrLabelText: NSMutableAttributedString
            
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(attributedString: lAttachmentString))
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(attributedString: lAttachmentString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            }
            
            self.attributedText = lStrLabelText
        }
    }
}



