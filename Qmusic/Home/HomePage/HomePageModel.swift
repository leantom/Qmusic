/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

extension Response {
    
    struct PlaylistWrapper: Codable {
        let reqID: String?
        let result: PlaylistWrapperResult?
        
        enum CodingKeys: String, CodingKey {

            case reqID = "reqID"
            case result = "result"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            reqID = try values.decodeIfPresent(String.self, forKey: .reqID)
            result = try values.decodeIfPresent(PlaylistWrapperResult.self, forKey: .result)
            
        }
    }
    
    struct PlaylistWrapperResult: Codable {
        let code: Int?
        let message: String?
        let langCode: String?
        let data: PlaylistDetail?
        
        enum CodingKeys: String, CodingKey {

            case code = "code"
            case message = "message"
            case langCode = "langCode"
            case data = "data"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            code = try values.decodeIfPresent(Int.self, forKey: .code)
            message = try values.decodeIfPresent(String.self, forKey: .message)
            langCode = try values.decodeIfPresent(String.self, forKey: .langCode)
            data = try values.decodeIfPresent(PlaylistDetail.self, forKey: .data)
        }
        
    }
    
    
    
    struct HomeSong: Codable {
        let reqID: String?
        let result: HomeSongResult?
        
        enum CodingKeys: String, CodingKey {

            case reqID = "reqID"
            case result = "result"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            reqID = try values.decodeIfPresent(String.self, forKey: .reqID)
            result = try values.decodeIfPresent(HomeSongResult.self, forKey: .result)
            
        }
        
    }
    struct HomeSongResult: Codable {
        let code: Int?
        let message: String?
        let langCode: String?
        let data: HomePageModel?
        
        enum CodingKeys: String, CodingKey {

            case code = "code"
            case message = "message"
            case langCode = "langCode"
            case data = "data"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            code = try values.decodeIfPresent(Int.self, forKey: .code)
            message = try values.decodeIfPresent(String.self, forKey: .message)
            langCode = try values.decodeIfPresent(String.self, forKey: .langCode)
            data = try values.decodeIfPresent(HomePageModel.self, forKey: .data)
        }
        
    }
}

struct HomePageModel : Codable {
    
	let status : Bool?
    let genres : [HomePage.Genres]?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case genres = "genres"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
        genres = try values.decodeIfPresent([HomePage.Genres].self, forKey: .genres)
	}

}
