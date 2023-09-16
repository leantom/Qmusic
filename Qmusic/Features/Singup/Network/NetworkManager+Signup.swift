//
//  NetworkManager+Signup.swift
//  Qmusic
//
//  Created by QuangHo on 28/08/2023.
//

import Foundation
import UIKit
import RxSwift

extension NetworkManager {
    
    func signupTemp(req: Request.Signup) {
        let params = try? req.asDictionary()
        let jsonData = try? JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
        var request = URLRequest(url: URL(string: "\(Constants.urlHost)user?api=signUp")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = jsonData
        
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
                        print("susscess :\(req.email)")
                    }
                    else {
                        let err = NSError(domain:"", code:httpResponse.statusCode, userInfo:nil)
                        print("fail :\(req.email)")
                    }
                } catch {
                    //MARK: observer onNext event
                    print("fail :\(req.email)")
                }
            }
            
        }
        task.resume()
        
    }
    
    
    func signup(req: Request.Signup) -> Observable<Response.SignUp> {
        let params = try? req.asDictionary()
        let jsonData = try? JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
        var request = URLRequest(url: URL(string: "\(Constants.urlHost)user?api=signUp")!,timeoutInterval: Double.infinity)
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
    
    func randomUser() {

        let headers = [
            "X-RapidAPI-Key": "LAW614Sbs9mshQpXupy9yRG24Aipp11WiV5jsn5q7O9MK5B2R0",
            "X-RapidAPI-Host": "random-user-by-api-ninjas.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://random-user-by-api-ninjas.p.rapidapi.com/v1/randomuser")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                guard let data = data else {return}
                do {
                    
                    let obj = try JSONDecoder().decode(RandomUser.self, from: data)
                    let req = Request.Signup(phone: "\(self.random(digits: 9))", email: obj.email ?? "", password: "123456".hash256())
                    self.signupTemp(req: req)
                    sleep(1)
                } catch let err{
                    print(err.localizedDescription)
                }
            }
        })

        dataTask.resume()
    }
    
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }

}


struct RandomUser : Codable {
    let username : String?
    let sex : String?
    let address : String?
    let name : String?
    let email : String?
    let birthday : String?

    enum CodingKeys: String, CodingKey {

        case username = "username"
        case sex = "sex"
        case address = "address"
        case name = "name"
        case email = "email"
        case birthday = "birthday"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        sex = try values.decodeIfPresent(String.self, forKey: .sex)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
    }

}
