/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
extension Response {
    struct SongDetailWrapper: Codable {
        let reqID: String?
        let result: SongDetailWrapperResult?
        
        enum CodingKeys: String, CodingKey {

            case reqID = "reqID"
            case result = "result"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            reqID = try values.decodeIfPresent(String.self, forKey: .reqID)
            result = try values.decodeIfPresent(SongDetailWrapperResult.self, forKey: .result)
            
        }
    }
    
    struct SongDetailWrapperResult: Codable {
        let code: Int?
        let message: String?
        let langCode: String?
        let data: SongDetailModel?
        
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
            data = try values.decodeIfPresent(SongDetailModel.self, forKey: .data)
        }
        
    }
}
struct SongDetailModel : Codable {
	let status : Bool?
    let soundcloudTrack : SongDetail.SoundcloudTrack?
    let spotifyTrack : SongDetail.SpotifyTrack?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case soundcloudTrack = "soundcloudTrack"
		case spotifyTrack = "spotifyTrack"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
        soundcloudTrack = try values.decodeIfPresent(SongDetail.SoundcloudTrack.self, forKey: .soundcloudTrack)
        spotifyTrack = try values.decodeIfPresent(SongDetail.SpotifyTrack.self, forKey: .spotifyTrack)
	}
    
    func getImageCover() -> String {
        guard let cover = self.spotifyTrack?.album?.cover?.last else {return ""}
        return cover.url ?? ""
    }

}
