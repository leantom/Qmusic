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
    // MARK: -- get link mp3 from youtube link
    func searchLinkMp3(linkURL: String,
                       completionHandler: @escaping(Result<YoutubeDataMP3, Error>) -> Void) {
        var isMobileLink = false
        if linkURL.contains("https://youtu.be") {
            isMobileLink = true
        }
        
        let exp = linkURL
        var splits = exp.components(separatedBy: "v=")
        if isMobileLink {
            splits = exp.components(separatedBy: "/")
        }
        
        //MARK: LINKMOBILE: https://youtu.be/C_SEHrguhIo
        guard let videoID = splits.last else{return}
        let headers = [
            "X-RapidAPI-Key": "LAW614Sbs9mshQpXupy9yRG24Aipp11WiV5jsn5q7O9MK5B2R0",
            "X-RapidAPI-Host": "youtube-mp36.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://youtube-mp36.p.rapidapi.com/dl?id=\(videoID)")! as URL,
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

                let jsonDecoder = JSONDecoder()
                do {
                    let object = try jsonDecoder.decode(YoutubeDataMP3.self, from: data)
                    completionHandler(.success(object))
                    print(object.status)
                } catch let err {
                    completionHandler(.failure(err))
                    print(err.localizedDescription)
                }
                
            }
        }


        dataTask.resume()
    }
    // MARK: -- getHomePageFromSpotify
    
    
    //MARK: getHomePage
    public func getHomePage()
    -> Observable<HomePageModel> {
        let headers = [
            "X-RapidAPI-Key": "LAW614Sbs9mshQpXupy9yRG24Aipp11WiV5jsn5q7O9MK5B2R0",
            "X-RapidAPI-Host": "spotify-scraper.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://spotify-scraper.p.rapidapi.com/v1/home?region=vn")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
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
                            let objs = try jsonDecoder.decode(HomePageModel.self, from:
                                                                _data)
                            AppSetting.shared.archiveDataHome(data: objs)
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
    
    //MARK: function for URLSession takes
    public func getPlaylistDetail(id: String)
    -> Observable<PlaylistDetail> {
        let headers = [
            "X-RapidAPI-Key": "LAW614Sbs9mshQpXupy9yRG24Aipp11WiV5jsn5q7O9MK5B2R0",
            "X-RapidAPI-Host": "spotify-scraper.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://spotify-scraper.p.rapidapi.com/v1/playlist/contents?playlistId=\(id)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        //MARK: creating our observable
        return Observable.create { observer in
            
            if let homeData = AppSetting.shared.getPlaylistDataFromLocal(id: id) {
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
                            let objs = try jsonDecoder.decode(PlaylistDetail.self, from:
                                                                _data)
                            AppSetting.shared.archiveDataPlaylist(data: objs, id: id)
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


