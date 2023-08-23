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
    
    public func archiveDataHome(data: HomePageModel) {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(data) {
            UserDefaults.standard.set(data, forKey: "homedata")
        }
    }
    
    // MARK: -- cho đỡ tiền request (thông cảm)
    func getHomeDataFromLocal() -> HomePageModel? {
        
        if let data =  UserDefaults.standard.object(forKey: "homedata"),
           let obj = try? JSONDecoder().decode(HomePageModel.self, from: data as! Data) {
            
            return obj
        }
        return nil
    }
    
    public func archiveDataPlaylist(data: PlaylistDetail, id: String) {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(data) {
            UserDefaults.standard.set(data, forKey: id)
        }
    }
    
    // MARK: -- cho đỡ tiền request (thông cảm)
    func getPlaylistDataFromLocal(id: String) -> PlaylistDetail? {
        
        if let data =  UserDefaults.standard.object(forKey: id),
           let obj = try? JSONDecoder().decode(PlaylistDetail.self, from: data as! Data) {
            
            return obj
        }
        return nil
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
