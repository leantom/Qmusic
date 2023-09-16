//
//  AppSetting.swift
//  Qmusic
//
//  Created by QuangHo on 21/08/2023.
//

import Foundation
import CoreData
import UIKit

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
    
    public func archiveDataSong(data: SongDetailModel, id: String) {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(data) {
            UserDefaults.standard.set(data, forKey: id)
        }
    }
    
    // MARK: -- cho đỡ tiền request (thông cảm)
    func getSongDataFromLocal(id: String) -> SongDetailModel? {
        
        if let data =  UserDefaults.standard.object(forKey: id),
           let obj = try? JSONDecoder().decode(SongDetailModel.self, from: data as! Data) {
            
            return obj
        }
        return nil
    }
    
    public func archiveDataYoutube(data: YoutubeMp3Info, id: String) {
        let encoder = JSONEncoder()
        saveYoutubeDataToCoreData(youtubeMP3Model: data)
        if let data = try? encoder.encode(data) {
            UserDefaults.standard.set(data, forKey: id)
        }
    }
    
    public func getDataYoutube(id: String) -> YoutubeMp3Info? {
        if let data =  UserDefaults.standard.object(forKey: id),
           let obj = try? JSONDecoder().decode(YoutubeMp3Info.self, from: data as! Data) {
            
            return obj
        }
        return nil
    }
    
    public func saveYoutubeDataToCoreData(youtubeMP3Model: YoutubeMp3Info) {

        let uuid = UIDevice.current.identifierForVendor!.uuidString

        let manageContent = appDelegate.persistentContainer.viewContext

        let userEntity = NSEntityDescription.entity(forEntityName: "YoutubeModel", in: manageContent)!

        let users = NSManagedObject(entity: userEntity, insertInto: manageContent)

        users.setValue(youtubeMP3Model.id, forKeyPath: "id")
        users.setValue(uuid, forKeyPath: "user")
        users.setValue(youtubeMP3Model.duration, forKeyPath: "duration")
        users.setValue(youtubeMP3Model.url, forKeyPath: "url")
        users.setValue(youtubeMP3Model.thumb, forKeyPath: "thumb")
        users.setValue(youtubeMP3Model.title, forKeyPath: "title")
        users.setValue(youtubeMP3Model.author, forKeyPath: "author")
        
        do{
            try manageContent.save()
        }catch let error as NSError {

            print("could not save . \(error), \(error.userInfo)")
        }

    }

    
    
    
}

protocol IUserDefault {
    var isLogin: Bool { get set }
    var userName: String { get set }
    var jwt: String { get set }
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
    
    var userName: String {
        get {
            return self.string(forKey: Keys.userName) ?? ""
        }
        set {
            self.setValue(newValue, forKey: Keys.userName)
        }
    }
    
    var jwt: String {
        get {
            return self.string(forKey: Keys.jwt) ?? ""
        }
        set {
            self.setValue(newValue, forKey: Keys.jwt)
        }
    }
    
    public enum Keys {
        static let isLogin = "isLogin"
        static let userName = "userName"
        static let jwt = "jwt"
    }
    
}
