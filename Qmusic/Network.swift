//
//  Network.swift
//  Qmusic
//
//  Created by QuangHo on 18/08/2023.
//

import Foundation
class NetworkYoutube: NSObject {
    static let sharedInstance = NetworkYoutube()
    
    func searchLinkMp3(linkURL: String,
                       completionHandler: @escaping(Result<YoutubeDataMP3, Error>) -> Void) {
        let exp = linkURL
        
        let splits = exp.components(separatedBy: "v=")
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
                print(httpResponse)
                guard let data = data else {
                    let err = NSError(domain:"", code:httpResponse?.statusCode ?? 1, userInfo:nil)
                    completionHandler(.failure(err))
                    return
                }
//
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
