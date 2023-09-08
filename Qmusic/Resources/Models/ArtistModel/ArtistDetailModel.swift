/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ArtistDetailModel : Codable {
	let status : Bool?
	let type : String?
	let id : String?
	let name : String?
	let shareUrl : String?
	let verified : Bool?
	let biography : String?
	let stats : Stats?
	let visuals : Visuals?
	let playlists : Playlists?
	let discography : Discography?
	let relatedContent : RelatedContent?
	let goods : Goods?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case type = "type"
		case id = "id"
		case name = "name"
		case shareUrl = "shareUrl"
		case verified = "verified"
		case biography = "biography"
		case stats = "stats"
		case visuals = "visuals"
		case playlists = "playlists"
		case discography = "discography"
		case relatedContent = "relatedContent"
		case goods = "goods"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		shareUrl = try values.decodeIfPresent(String.self, forKey: .shareUrl)
		verified = try values.decodeIfPresent(Bool.self, forKey: .verified)
		biography = try values.decodeIfPresent(String.self, forKey: .biography)
		stats = try values.decodeIfPresent(Stats.self, forKey: .stats)
		visuals = try values.decodeIfPresent(Visuals.self, forKey: .visuals)
		playlists = try values.decodeIfPresent(Playlists.self, forKey: .playlists)
		discography = try values.decodeIfPresent(Discography.self, forKey: .discography)
		relatedContent = try values.decodeIfPresent(RelatedContent.self, forKey: .relatedContent)
		goods = try values.decodeIfPresent(Goods.self, forKey: .goods)
	}

}
