//
//  Network.swift
//  Qmusic
//
//  Created by QuangHo on 18/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class NetworkManager: NSObject {
    static let sharedInstance = NetworkManager()
    internal var jwt = ""
    // MARK: -- get link mp3 from youtube link
    func getLyric(id: String,
                       completionHandler: @escaping(Result<String, Error>) -> Void) {
        
        //MARK: LINKMOBILE:
        let headers = [
            "X-RapidAPI-Key": "LAW614Sbs9mshQpXupy9yRG24Aipp11WiV5jsn5q7O9MK5B2R0",
            "X-RapidAPI-Host": "spotify-scraper.p.rapidapi.com"
        ]
    
        let request = NSMutableURLRequest(url: NSURL(string: "https://spotify-scraper.p.rapidapi.com/v1/track/lyrics?trackId=\(id)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if (error != nil) {
                print(error as Any)
                completionHandler(.failure(error!))
            } else {
                let httpResponse = response as? HTTPURLResponse
                
                guard let data = data else {
                    let err = NSError(domain:"", code:httpResponse?.statusCode ?? 1, userInfo:nil)
                    completionHandler(.failure(err))
                    return
                }
                let object = String(data: data, encoding: .utf8) ?? ""
                completionHandler(.success(object))
                
            }
        }


        dataTask.resume()
    }
    
    // MARK: -- get link mp3 from youtube link
    func searchLinkMp3(linkURL: String) -> Observable<YoutubeMp3Model> {
        // Mobile link: https://youtu.be/SJzFq4IfXQw?si=_kyDRBs7kfkA8xfG
        var id = ""
        if let url = URLComponents(string: linkURL),
            let queryItems = url.queryItems {
            if let idItem = queryItems.filter({$0.name == "v"}).first {
                id = idItem.value ?? ""
            }
            if id.isEmpty {
                id = url.path.replacingOccurrences(of: "/", with: "")
            }
            
            print(queryItems)
        }
        
        
        let headers = [
            "X-RapidAPI-Key": "LAW614Sbs9mshQpXupy9yRG24Aipp11WiV5jsn5q7O9MK5B2R0",
            "X-RapidAPI-Host": "ytstream-download-youtube-videos.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://ytstream-download-youtube-videos.p.rapidapi.com/dl?id=\(id)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        //MARK: creating our observable
        return Observable.create { observer in

            
            if let homeData = AppSetting.shared.getDataYoutube(id: id),
               let bitrate = getBitrateMax(youtubeMp3Model: homeData)
            {
                
                if let audioURL = bitrate.url,
                   let url = URLComponents(string: audioURL),
                   let queryItems = url.queryItems,
                   let expires = queryItems.filter({$0.name == "expire"}).first,
                   let expireTimestamp = Int(expires.value ?? ""){
                    if Date().currentTimeMillis() > expireTimestamp {
                        print("Song is expire")
                    } else {
                        observer.onNext(homeData)
                        observer.onCompleted()
                        return Disposables.create {}
                    }
                    
                }
            }
            
            //MARK: create URLSession dataTask
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { (data,
                                                          response, error) in
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    let jsonDecoder = JSONDecoder()
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try jsonDecoder.decode(YoutubeMp3Model.self, from:
                                                                _data)
                            AppSetting.shared.archiveDataYoutube(data: objs, id: id)
                            //MARK: observer onNext event
                            observer.onNext(objs)
                        }
                        else {
                            let err = NSError(domain:"", code:httpResponse.statusCode, userInfo:nil)
                            observer.onError(err)
                        }
                    } catch {
                        //MARK: observer onNext event
                        observer.onError(error)
                    }
                }
                //MARK: observer onCompleted event
                observer.onCompleted()
            }
            task.resume()
            //MARK: return our disposable
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    // MARK: -- getHomePageFromSpotify
    
    
    //MARK: getHomePage
    public func getHomePage()
    -> Observable<HomePageModel> {
//        let headers = [
//            "X-RapidAPI-Key": "LAW614Sbs9mshQpXupy9yRG24Aipp11WiV5jsn5q7O9MK5B2R0",
//            "X-RapidAPI-Host": "spotify-scraper.p.rapidapi.com"
//        ]

//        let request = NSMutableURLRequest(url: NSURL(string: "https://spotify-scraper.p.rapidapi.com/v1/home?region=vn")! as URL,
//                                                cachePolicy: .useProtocolCachePolicy,
//                                            timeoutInterval: 10.0)
        
        var request = URLRequest(url: URL(string: "https://c2ojyq8681.execute-api.ap-southeast-1.amazonaws.com/Prod/user?api=songHome")!,timeoutInterval: Double.infinity)
        request.addValue(jwt, forHTTPHeaderField: "auth")
        request.addValue("false", forHTTPHeaderField: "isExpired")
        
        request.httpMethod = "GET"
        
        
        //MARK: creating our observable
        return Observable.create { observer in
            
            if let homeData = AppSetting.shared.getHomeDataFromLocal() {
                observer.onNext(homeData)
                observer.onCompleted()
                return Disposables.create {}
            }
            
            //MARK: create URLSession dataTask
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { (data,
                                                          response, error) in
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    let jsonDecoder = JSONDecoder()
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try jsonDecoder.decode(Response.HomeSong.self, from:
                                                                _data)
                            if let data = objs.result?.data {
                                AppSetting.shared.archiveDataHome(data: data)
                                observer.onNext(data)
                            } else {
                                let err = NSError(domain:"", code:5, userInfo:nil)
                                observer.onError(err)
                            }
                            
                            //MARK: observer onNext event
                            
                        }
                        else {
                            let err = NSError(domain:"", code:httpResponse.statusCode, userInfo:nil)
                            observer.onError(err)
                        }
                    } catch {
                        //MARK: observer onNext event
                        observer.onError(error)
                    }
                }
                //MARK: observer onCompleted event
                observer.onCompleted()
            }
            task.resume()
            //MARK: return our disposable
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    //MARK: getPlaylistDetail
    public func getPlaylistDetail(id: String)
    -> Observable<PlaylistDetail> {
        
        
//        let headers = [
//            "X-RapidAPI-Key": "LAW614Sbs9mshQpXupy9yRG24Aipp11WiV5jsn5q7O9MK5B2R0",
//            "X-RapidAPI-Host": "spotify-scraper.p.rapidapi.com"
//        ]
//
//        let request = NSMutableURLRequest(url: NSURL(string: "https://spotify-scraper.p.rapidapi.com/v1/playlist/contents?playlistId=\(id)")! as URL,
//                                                cachePolicy: .useProtocolCachePolicy,
//                                            timeoutInterval: 10.0)

        
        
        var request = URLRequest(url: URL(string: "https://c2ojyq8681.execute-api.ap-southeast-1.amazonaws.com/Prod/user?api=playList&playlistId=\(id)")!,timeoutInterval: Double.infinity)
        request.addValue(jwt, forHTTPHeaderField: "auth")
        request.addValue("false", forHTTPHeaderField: "isExpired")
        //request.allHTTPHeaderFields = headers

        request.httpMethod = "GET"
        
        
        //MARK: creating our observable
        return Observable.create { observer in
          
            if let homeData = AppSetting.shared.getPlaylistDataFromLocal(id: id),
               homeData.contents != nil {

                observer.onNext(homeData)
                observer.onCompleted()
                return Disposables.create {}
            }
//            
            //MARK: create URLSession dataTask
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { (data,
                                                          response, error) in
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    let jsonDecoder = JSONDecoder()
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            

                            do {
                                let myJson = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                                print(myJson)

                            } catch let error {
                                   print(error)
                            }
                            let objs = try jsonDecoder.decode(Response.PlaylistWrapper.self, from:
                                                                _data)
                            if let playlist = objs.result?.data {
                                AppSetting.shared.archiveDataPlaylist(data: playlist, id: id)
                                observer.onNext(playlist)
                            } else {
                                let err = NSError(domain:"", code:5, userInfo:nil)
                                observer.onError(err)
                            }
                            //MARK: observer onNext event
                            
                        }
                        else {
                            let err = NSError(domain:"", code:httpResponse.statusCode, userInfo:nil)
                            observer.onError(err)
                        }
                    } catch {
                        //MARK: observer onNext event
                        observer.onError(error)
                    }
                }
                //MARK: observer onCompleted event
                observer.onCompleted()
            }
            task.resume()
            //MARK: return our disposable
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    // MARK: -- getDetailSong
    public func getDetailSong(id: String)
    -> Observable<SongDetailModel> {
        let headers = [
            "X-RapidAPI-Key": "LAW614Sbs9mshQpXupy9yRG24Aipp11WiV5jsn5q7O9MK5B2R0",
            "X-RapidAPI-Host": "spotify-scraper.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://spotify-scraper.p.rapidapi.com/v1/track/download/soundcloud?track=\(id)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        //MARK: creating our observable
        return Observable.create { observer in
            
            if let homeData = AppSetting.shared.getSongDataFromLocal(id: id) {
                if let audioURL = homeData.soundcloudTrack?.audio?.first?.url,
                let url = URLComponents(string: audioURL),
                   let queryItems = url.queryItems,
                   let expire = queryItems.first?.value,
                   let expireTimestamp = Int(expire){
                    if Date().currentTimeMillis() > expireTimestamp {
                        print("Song is expire")
                    } else {
                        observer.onNext(homeData)
                        observer.onCompleted()
                        return Disposables.create {}
                    }
                    
                }
            }
            
            //MARK: create URLSession dataTask
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { (data,
                                                          response, error) in
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    let jsonDecoder = JSONDecoder()
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try jsonDecoder.decode(SongDetailModel.self, from:
                                                                _data)
                            AppSetting.shared.archiveDataSong(data: objs, id: id)
                            //MARK: observer onNext event
                            observer.onNext(objs)
                        }
                        else {
                            let err = NSError(domain:"", code:httpResponse.statusCode, userInfo:nil)
                            observer.onError(err)
                        }
                    } catch {
                        //MARK: observer onNext event
                        observer.onError(error)
                    }
                }
                //MARK: observer onCompleted event
                observer.onCompleted()
            }
            task.resume()
            //MARK: return our disposable
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    
    func addPlaylistToDB(req: Request.Playlist) {
        
        do {
            let params = try req.asDictionary()
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            var request = URLRequest(url: URL(string: "https://c2ojyq8681.execute-api.ap-southeast-1.amazonaws.com/Prod/test?api=insertPlayList")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            request.httpMethod = "POST"
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                print(String(describing: error))
                return
              }
              print(String(data: data, encoding: .utf8)!)
            }

            task.resume()
        } catch let err{
            print(err.localizedDescription)
        }
        
    }
    
    
    func addSongToDB(req: Request.Song) {
    
        do {
            let params = try req.asDictionary()
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            var request = URLRequest(url: URL(string: "https://c2ojyq8681.execute-api.ap-southeast-1.amazonaws.com/Prod/test?api=insertSong")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            request.httpMethod = "POST"
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                print(String(describing: error))
                return
              }
              print(String(data: data, encoding: .utf8)!)
            }

            task.resume()
        } catch let err{
            print(err.localizedDescription)
        }
        

    }
    
    
    func addArtistToDB(req: Request.Artist,
                       completionHandler: @escaping(Result<Int, Error>) -> Void) {
        
        do {
            let params = try req.asDictionary()
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            var request = URLRequest(url: URL(string: "https://c2ojyq8681.execute-api.ap-southeast-1.amazonaws.com/Prod/test?api=insertArtist")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            request.httpMethod = "POST"
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    completionHandler(.failure(error!))
                    return
                }
                completionHandler(.success(0))
                print(String(data: data, encoding: .utf8)!)
            }
            
            task.resume()
        } catch let err{
            completionHandler(.failure(err))
            print(err.localizedDescription)
        }

    }
    
    func addAvatarToDB() {
        let parameters = "{\n    \"id\": \"\",\n    \"url\": \"\",\n    \"artistId\": \"\",\n    \"width\": 0,\n    \"height\": 0\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://c2ojyq8681.execute-api.ap-southeast-1.amazonaws.com/Prod/test?api=insertAvatar")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    func addAlbumToDB(req: Request.Playlist) {
        
        
        do {
            let params = try req.asDictionary()
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            var request = URLRequest(url: URL(string: "https://c2ojyq8681.execute-api.ap-southeast-1.amazonaws.com/Prod/test?api=insertAlbumArtist")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            request.httpMethod = "POST"
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                print(String(describing: error))
                return
              }
              print(String(data: data, encoding: .utf8)!)
            }

            task.resume()
        } catch let err{
            print(err.localizedDescription)
        }
        
    }
    
    func uploadSong(req: Request.UploadMP3,
                    completionHandler: @escaping(Result<Int, Error>) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://c2ojyq8681.execute-api.ap-southeast-1.amazonaws.com/Prod/test?api=uploadMp3")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: req.asDictionary(), options: .prettyPrinted)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
              completionHandler(.failure(error!))
            return
          }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // try to read out a dictionary
                if let msg = json["message"] as? String,
                   msg == "Success" {
                    completionHandler(.success(0))
                } else {
                    let err = NSError(domain:"", code:5, userInfo:nil)
                    completionHandler(.failure(err))
                }
            }
          print(String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    
    
    
}

struct YoutubeDataMP3: Codable {
    var link: String
    var filesize: Float
    var title: String
    var progress: Float
    var duration: Float
    var status: String
    var msg: String
}


