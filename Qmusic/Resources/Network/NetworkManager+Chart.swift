//
//  NetworkManager+Chart.swift
//  Qmusic
//
//  Created by QuangHo on 25/09/2023.
//

import Foundation
import RxSwift

extension NetworkManager {
    func getChart() -> Observable<[TopTracks]> {
        
        
        var request = URLRequest(url: URL(string: "\(Constants.urlHost)user?api=chart")!,timeoutInterval: Double.infinity)
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
                            
                            do {
                                let myJson = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                                print(myJson)

                            } catch let error {
                                   print(error)
                            }
                            
                            let objs = try jsonDecoder.decode(ChartWrapper.self, from:
                                                                _data)
                            if let obj = objs.result?.data?.tracks?.items {
                                observer.onNext(obj)
                            } else {
                                let err = NSError(domain:"", code:httpResponse.statusCode, userInfo:nil)
                                observer.onError(err)
                            }
                        }
                        else {
                            let err = NSError(domain:"", code:httpResponse.statusCode, userInfo:nil)
                            observer.onError(err)
                        }
                    }
                    catch let DecodingError.dataCorrupted(context) {
                        print("corrupted data \(context)")
                        
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found: \(context.debugDescription)")
                        print("codingPath: \(context.codingPath)")
                        
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        
                    }  catch {
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

struct ChartWrapper: Codable {
    let reqID : String?
    let result : ChartResult?
    enum CodingKeys: String, CodingKey {

        case reqID = "reqID"
        case result = "result"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reqID = try values.decodeIfPresent(String.self, forKey: .reqID)
        result = try values.decodeIfPresent(ChartResult.self, forKey: .result)
    }
}

struct ChartResult:Codable {
    let code : Int?
    let message : String?
    let langCode : String?
    let isCache : Bool?
    let data : ChartData?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case langCode = "langCode"
        case isCache = "isCache"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        langCode = try values.decodeIfPresent(String.self, forKey: .langCode)
        isCache = try values.decodeIfPresent(Bool.self, forKey: .isCache)
        data = try values.decodeIfPresent(ChartData.self, forKey: .data)
    }
}


struct ChartData: Codable {
    let status: Bool?
    let tracks:ChartTrack?
    
    enum CodingKeys: String, CodingKey {

        case status = "status"
        case tracks = "tracks"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        tracks = try values.decodeIfPresent(ChartTrack.self, forKey: .tracks)
    }
    
}
struct ChartTrack: Codable {
    let totalCount: Int?
    let items:[TopTracks]?
    
    enum CodingKeys: String, CodingKey {

        case totalCount = "totalCount"
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
        items = try values.decodeIfPresent([TopTracks].self, forKey: .items)
    }
    
}
