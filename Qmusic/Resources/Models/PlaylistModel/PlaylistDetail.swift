/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct PlaylistDetail : Codable {
    let status : Bool?
    var contents : PlaylistModel.Contents?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case contents = "contents"
    }

    

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
        do {
            contents = try values.decodeIfPresent(PlaylistModel.Contents.self, forKey: .contents)
        } catch let DecodingError.dataCorrupted(context) {
            print("corrupted data \(context)")
            self.contents = nil
            
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found: \(context.debugDescription)")
            print("codingPath: \(context.codingPath)")
            self.contents = nil
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            self.contents = nil
            
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            self.contents = nil
        }  catch let err{
            print(err)
            self.contents = nil
        }
        
	}

}

struct Request {
    struct Playlist: Codable {
        let id: String
        let type: String
        let name: String
        let description: String
        
        let trackCount: Int
        let followerCount: Int
        let cover: String
        let shareurlSpotify: String
        
        let shareurlApp: String
        let likeCount: Int
        let status: Int
    }
    
    struct Song: Codable {
        let id: String
        let type: String
        let name: String
        let artistId: String
        
        let durationms: Int
        let durationText: String
        let albumId: String
        let url: String
        
        let mimeType: String
        let likeCount: Int
        let lyricId: String
        
        let shareurlApp: String
        
    }
    
    struct Artist: Codable {
        let id: String
        let verified: Int
        let name: String
    }
    
    struct UploadMP3: Codable {
        let url: String
        let songID: String
        let songName: String
    }
    
    /**
     {
         "id": "",
         "type": "",
         "name": "",
         "description": "",
         "trackCount": 0,
         "followerCount": 0,
         "cover": "",
         "shareurlSpotify": "",
         "shareurlApp": "",
         "likeCount": 0,
         "status": 0
     }
     */
    struct Album: Codable {
        let id: String
        let type: String
        let name: String
        let description: String
        
        let trackCount: Int
        let followerCount: Int
        let cover: String
        let shareurlSpotify: String
        
        let shareurlApp: String
        let likeCount: Int
        let status: Int
    }
    
}


extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
