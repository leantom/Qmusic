//
//  AppSetting.swift
//  Qmusic
//
//  Created by QuangHo on 21/08/2023.
//

import Foundation
class AppSetting: NSObject {
    static let shared = AppSetting()
    
   private var methodLogin: LoginInWithMethod = .Normal
    private var userDefault: IUserDefault
    
    init(userDefault: UserDefaults = .standard) {
        self.userDefault = userDefault
    }
    
    public func setStatusLogin(status: Bool) {
        self.userDefault.isLogin = status
    }
    
    public func getStatusLogin() -> Bool {
        return self.userDefault.isLogin
    }
    
}

protocol IUserDefault {
    var isLogin: Bool { get set }
}


extension UserDefaults: IUserDefault {
    var isLogin: Bool {
        get {
            return self.bool(forKey: Keys.isLogin)
        }
        set {
            self.setValue(newValue, forKey: Keys.isLogin)
        }
    }
    
    public enum Keys {
        static let isLogin = "isLogin"
        
    }
    
}
