/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import CoreData

struct YoutubeMp3Model : Codable {
	let status : String?
	let id : String?
	let title : String?
	let lengthSeconds : String?
	let keywordswords : [String]?
	let channelTitle : String?
	let channelId : String?
	let description : String?
	let thumbnail : [Thumbnail]?
	let allowRatings : Bool?
	let viewCount : String?
	let isPrivate : Bool?
	let isUnpluggedCorpus : Bool?
	let isLiveContent : Bool?
	let captions : Captions?
	let expiresInSeconds : String?
	let formats : [Formats]?
	let adaptiveFormats : [AdaptiveFormats]?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case id = "id"
		case title = "title"
		case lengthSeconds = "lengthSeconds"
		case keywordswords = "keywords"
		case channelTitle = "channelTitle"
		case channelId = "channelId"
		case description = "description"
		case thumbnail = "thumbnail"
		case allowRatings = "allowRatings"
		case viewCount = "viewCount"
		case isPrivate = "isPrivate"
		case isUnpluggedCorpus = "isUnpluggedCorpus"
		case isLiveContent = "isLiveContent"
		case captions = "captions"
		case expiresInSeconds = "expiresInSeconds"
		case formats = "formats"
		case adaptiveFormats = "adaptiveFormats"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		lengthSeconds = try values.decodeIfPresent(String.self, forKey: .lengthSeconds)
        keywordswords = try values.decodeIfPresent([String].self, forKey: .keywordswords)
		channelTitle = try values.decodeIfPresent(String.self, forKey: .channelTitle)
		channelId = try values.decodeIfPresent(String.self, forKey: .channelId)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		thumbnail = try values.decodeIfPresent([Thumbnail].self, forKey: .thumbnail)
		allowRatings = try values.decodeIfPresent(Bool.self, forKey: .allowRatings)
		viewCount = try values.decodeIfPresent(String.self, forKey: .viewCount)
		isPrivate = try values.decodeIfPresent(Bool.self, forKey: .isPrivate)
		isUnpluggedCorpus = try values.decodeIfPresent(Bool.self, forKey: .isUnpluggedCorpus)
		isLiveContent = try values.decodeIfPresent(Bool.self, forKey: .isLiveContent)
		captions = try values.decodeIfPresent(Captions.self, forKey: .captions)
		expiresInSeconds = try values.decodeIfPresent(String.self, forKey: .expiresInSeconds)
		formats = try values.decodeIfPresent([Formats].self, forKey: .formats)
		adaptiveFormats = try values.decodeIfPresent([AdaptiveFormats].self, forKey: .adaptiveFormats)
        
        
        
        
        
	}
    func getThumbnailSmall() -> URL? {
        
        guard let thumbnails = self.thumbnail else {return nil}
        return URL(string: thumbnails.first?.url ?? "")
    }
    
    func getBitrateMax() -> AdaptiveFormats? {
        
        guard let adaptiveFormats = self.adaptiveFormats else {return nil}
        
        let formats = adaptiveFormats.filter({
            guard let mimeType = $0.mimeType else {return false}
            return mimeType.contains("audio/mp4")
            
        })
        
        if let bitrate = formats.sorted(by: { item1, item2 in
            guard let bitrate1 = item1.bitrate else {return false}
            guard let bitrate2 = item2.bitrate else {return false}
            return bitrate1 > bitrate2
        }).first {
            return bitrate
        }
        return adaptiveFormats.first
    }
    
    

}
