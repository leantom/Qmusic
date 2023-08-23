//
//  WEExtensions+Notification.Name.swift
//  facepay_v3
//
//  Created by Nguyen Thanh Duc on 27/11/2020.
//

import Foundation

public extension Notification.Name {
    static let noInternetConnection = Notification.Name("noInternetConnection")
    static let reconnectInternetConnection = Notification.Name("reconnectInternetConnection")
    static let cellularInternetConnection = Notification.Name("cellularInternetConnection")
    
    static let appBecomActive = Notification.Name("app.becom.active.notification")
    
    static let updatedAvatarStatus = Notification.Name("updatedAvatarStatus")
    
    static let updatedMailSuccess = Notification.Name("updatedMailSuccess")
    static let unlockAppFinish = Notification.Name("unlockAppFinish")
    static let hideKeyboard = Notification.Name("hideKeyboard")
    static let outToLogin = Notification.Name("outToLogin")
    
    static let songplayfinished = Notification.Name("songplayfinished")
    
    
}
