//
//  NetworkManager+Genres.swift
//  Qmusic
//
//  Created by QuangHo on 24/09/2023.
//

import Foundation
import RxSwift

extension NetworkManager {
    //MARK: getPlaylistDetail
   /*
    7/ Nhạc Acoustic .
    6/ Nhạc Bolero
    5/ Nhạc Dance hay Nhạc Remix
    4/ Nhạc Pop
    3/ Nhạc KPop
    2/ Nhạc Ballad .
    1/ Nhạc Rap .
    */
    
    
    public func getGenreDetail(id: String)
    -> Observable<GenresDetail> {

        var request = URLRequest(url: URL(string: "\(Constants.urlHost)user?api=genre&genreId=\(id)")!,timeoutInterval: Double.infinity)
        request.addValue(jwt, forHTTPHeaderField: "auth")
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
                            

                            do {
                                let myJson = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                                print(myJson)

                            } catch let error {
                                   print(error)
                            }
                            let objs = try jsonDecoder.decode(Response.GenresWrapper.self, from:
                                                                _data)
                            if let genres = objs.result?.data {
                                observer.onNext(genres)
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
}
