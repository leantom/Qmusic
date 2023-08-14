//
//  WEExtensions+Data.swift
//  FEMobile
//
//  Created by MrDatto on 20/08/2021.
//

import Foundation
import CommonCrypto

extension Data{
    
    
    
    func convertToArrInt() -> [Int]{
        do {
            let IntArray = try JSONSerialization.jsonObject(with: self, options:[])
            return IntArray as! [Int]
        }catch{
            return []
        }
    }
    
    func convertToArr() -> [AnyObject]{
        do {
            let Array = try JSONSerialization.jsonObject(with: self, options:[])
            return Array as! [AnyObject]
        }catch{
            return []
        }
    }
    
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }

    
    public func sha256() -> String{
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

extension Int {
    func formatTimerCoundownForMins() -> String {
        let dateFormat = DateComponentsFormatter()
        dateFormat.unitsStyle = .positional
        dateFormat.allowedUnits = [.minute, .second]
        dateFormat.zeroFormattingBehavior = [.pad]
        let format = dateFormat.string(from: TimeInterval(self))!
        return format
    }
}
