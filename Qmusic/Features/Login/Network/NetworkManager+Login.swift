//
//  NetworkManager+Login.swift
//  Qmusic
//
//  Created by QuangHo on 29/08/2023.
//

import Foundation
import RxSwift
extension NetworkManager {
    func signin(req: Request.SignIn) -> Observable<Response.SignUp> {
        let params = try? req.asDictionary()
        let jsonData = try? JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
        var request = URLRequest(url: URL(string: "\(Constants.urlHost)user?api=signIn")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        //MARK: creating our observable
        return Observable.create { observer in
           
            //MARK: create URLSession dataTask
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { (data,
                                                          response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    let jsonDecoder = JSONDecoder()
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try jsonDecoder.decode(Response.SignUp.self, from:
                                                                _data)
                            //MARK: observer onNext event
                            observer.onNext(objs)
                            self.jwt = objs.result?.jwt ?? ""
                            UserDefaults.standard.jwt = self.jwt
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
    
    func checkEmailToResetPassword(email: String) -> Observable<Response.CheckEmail> {
        
        let parameters = "{\n    \"email\": \"\(email)\"\n}"
        let postData = parameters.data(using: .utf8)
   
        var request = URLRequest(url: URL(string: "\(Constants.urlHost)user?api=checkEmail")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        //MARK: creating our observable
        return Observable.create { observer in
           
            
            //MARK: create URLSession dataTask
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { (data,
                                                          response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    let jsonDecoder = JSONDecoder()
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try jsonDecoder.decode(Response.CheckEmail.self, from:
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
    
    
    func changePassword(email: String) -> Observable<Response.CheckEmail> {
        
        let parameters = "{\n    \"email\": \"\(email)\"\n}"
        let postData = parameters.data(using: .utf8)
   
        var request = URLRequest(url: URL(string: "\(Constants.urlHost)user?api=checkEmail")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData
        
        //MARK: creating our observable
        return Observable.create { observer in
           
            
            //MARK: create URLSession dataTask
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { (data,
                                                          response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    let jsonDecoder = JSONDecoder()
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try jsonDecoder.decode(Response.CheckEmail.self, from:
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
