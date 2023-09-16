//
//  NetworkManager+Comment.swift
//  Qmusic
//
//  Created by QuangHo on 15/09/2023.
//

import Foundation
import RxSwift
import UIKit

extension NetworkManager {
    // MARK: -- getDetailSong
    public func addCommentSong(req : Request.CommentSong)
    -> Observable<SongDetailModel> {
        let data = try! req.asDictionary()
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        var request = URLRequest(url: URL(string: "\(Constants.urlHost)user?api=commentSong")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
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
                            print("Comment thành công: \(req.songId)")
                            
                        }
                        else {
                            let err = NSError(domain:"", code:httpResponse.statusCode, userInfo:nil)
                            observer.onError(err)
                            print("Comment thất bại: \(req.songId)")
                        }
                    } catch {
                        //MARK: observer onNext event
                        observer.onError(error)
                        print("Comment thất bại: \(req.songId)")
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
    
    public func addCommentSongTemp(req : Request.CommentSong) {
        let data = try! req.asDictionary()
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
        var request = URLRequest(url: URL(string: "\(Constants.urlHost)user?api=commentSong")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(self.jwt, forHTTPHeaderField: "auth")
        request.httpMethod = "POST"
        request.httpBody = jsonData
            
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data,
                                                      response, error) in
            if let httpResponse = response as? HTTPURLResponse{
                let statusCode = httpResponse.statusCode
                let jsonDecoder = JSONDecoder()
                do {
                    let _data = data ?? Data()
                    if (200...399).contains(statusCode) {
                        print("Comment thành công: \(req.songId)")
                        
                    }
                    else {
                        let err = NSError(domain:"", code:httpResponse.statusCode, userInfo:nil)
                       
                        print("Comment thất bại: \(req.songId)")
                    }
                } catch {
                    //MARK: observer onNext event
                    
                    print("Comment thất bại: \(req.songId)")
                }
            }
        }
        task.resume()
        
    }
    
    func getCommentPositiveChatGPT(name artist: String, song: String, songID: String) {
        do {
            let headers = [
                "content-type": "application/json",
                "X-RapidAPI-Key": "LAW614Sbs9mshQpXupy9yRG24Aipp11WiV5jsn5q7O9MK5B2R0",
                "X-RapidAPI-Host": "open-ai21.p.rapidapi.com"
            ]
            let parameters = ["messages": [
                    [
                        "role": "user",
                        "content": "cảm nghĩ của bạn về bài hát \(song) - \(artist) , giới hạn 50 từ."
                    ]
                ]] as [String : Any]

            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

            let request = NSMutableURLRequest(url: NSURL(string: "https://open-ai21.p.rapidapi.com/conversationgpt")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 30.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error as Any)
                } else {
                    let _data = data ?? Data()
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                        if let commentStr = myJson["GPT"] as? String {
                            let req = Request.CommentSong(songId: songID, comment: commentStr)
                            self.addCommentSongTemp(req: req)
                        }
                        print(myJson)

                    } catch let error {
                           print(error)
                    }
                    
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse as Any)
                }
            })

            dataTask.resume()
        } catch let err{
            print(err.localizedDescription)
        }
        
    }
    
    func getCommentNegativeChatGPT(name artist: String, song: String, songID: String) {
        do {
            let headers = [
                "content-type": "application/json",
                "X-RapidAPI-Key": "LAW614Sbs9mshQpXupy9yRG24Aipp11WiV5jsn5q7O9MK5B2R0",
                "X-RapidAPI-Host": "open-ai21.p.rapidapi.com"
            ]
            let parameters = ["messages": [
                    [
                        "role": "user",
                        "content": "những điều cần cải thiện trong bài hát \(song) - \(artist) , giới hạn 50 từ."
                    ]
                ]] as [String : Any]

            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

            let request = NSMutableURLRequest(url: NSURL(string: "https://open-ai21.p.rapidapi.com/conversationgpt")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 30.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error as Any)
                } else {
                    let _data = data ?? Data()
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                        if let commentStr = myJson["GPT"] as? String {
                            let req = Request.CommentSong(songId: songID, comment: commentStr)
                            self.addCommentSongTemp(req: req)
                        }
                        print(myJson)

                    } catch let error {
                           print(error)
                    }
                    
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse as Any)
                }
            })

            dataTask.resume()
        } catch let err{
            print(err.localizedDescription)
        }
        
    }
    
    
    func showAlertView(desc: String) {
        let ac = UIAlertController(title: "Thông báo", message: desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default) { alert in
            
        })
        if let topVc = UIApplication.getTopViewController() {
            topVc.present(ac, animated: true)
        }
        
    }
    
}
