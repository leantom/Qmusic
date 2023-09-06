//
//  NetworkManager+GetAlbum.swift
//  Qmusic
//
//  Created by QuangHo on 28/08/2023.
//

import Foundation
import RxSwift

extension NetworkManager {

    //MARK: getAlbumByID
    public func getAlbumByID(id: String)
    -> Observable<AlbumDetail> {
        
        var request = URLRequest(url: URL(string: "\(Constants.urlHost)user?api=album&albumId=\(id)")!,timeoutInterval: Double.infinity)
        request.addValue(self.jwt, forHTTPHeaderField: "auth")
        request.addValue("false", forHTTPHeaderField: "isExpired")

        request.httpMethod = "GET"
        
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
                            let objs = try jsonDecoder.decode(Response.AlbumWrapper.self, from:
                                                                _data)
                            
                            
                            if let data = objs.result?.data {
//                                AppSetting.shared.archiveDataHome(data: data)
                                observer.onNext(data)
                            } else {
                                let err = NSError(domain:objs.result?.message ?? "", code:5, userInfo:nil)
                                observer.onError(err)
                            }
                            
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
    
    
    //MARK: getAlbumByID
    public func getAlbumMetadataByID(id: String)
    -> Observable<AlbumMetadata> {
        
        let headers = [
            "X-RapidAPI-Key": "LAW614Sbs9mshQpXupy9yRG24Aipp11WiV5jsn5q7O9MK5B2R0",
            "X-RapidAPI-Host": "spotify-scraper.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://spotify-scraper.p.rapidapi.com/v1/album/metadata?albumId=\(id)")! as URL,
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
                            let objs = try jsonDecoder.decode(AlbumMetadata.self, from:
                                                                _data)
                            
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
