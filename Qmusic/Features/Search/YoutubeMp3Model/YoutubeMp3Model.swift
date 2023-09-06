

import Foundation

struct YoutubeMp3Info : Codable {
	let status : String?
	let id : String?
	let title : String?
	let author : String?
	let thumb : String?
    var url: String = ""
    var duration: Float = 1
    var expireTimestamp: Double = 0
    
	enum CodingKeys: String, CodingKey {

		case status = "status"
		case id = "id"
		case title = "title"
		case author = "author"
		case thumb = "thumb"
		
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		author = try values.decodeIfPresent(String.self, forKey: .author)
		thumb = try values.decodeIfPresent(String.self, forKey: .thumb)
	}
    
    init(status: String, id: String, title: String, author: String, thumb: String, url: String, duration: Float, expire: Double) {
        self.status = status
        self.id = id
        self.title = title
        
        self.author = author
        self.thumb = thumb
        self.url = url
        self.duration = duration
        self.expireTimestamp = expire
    }

}
