/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct AdaptiveFormats : Codable {
	let itag : Int?
	let url : String?
	let mimeType : String?
	let bitrate : Int?
	let width : Int?
	let height : Int?
	let initRange : InitRange?
	let indexRange : YT_IndexRange?
	let lastModified : String?
	let contentLength : String?
	let quality : String?
	let fps : Int?
	let qualityLabel : String?
	let projectionType : String?
	let averageBitrate : Int?
	let approxDurationMs : String?

	enum CodingKeys: String, CodingKey {

		case itag = "itag"
		case url = "url"
		case mimeType = "mimeType"
		case bitrate = "bitrate"
		case width = "width"
		case height = "height"
		case initRange = "initRange"
		case indexRange = "indexRange"
		case lastModified = "lastModified"
		case contentLength = "contentLength"
		case quality = "quality"
		case fps = "fps"
		case qualityLabel = "qualityLabel"
		case projectionType = "projectionType"
		case averageBitrate = "averageBitrate"
		case approxDurationMs = "approxDurationMs"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		itag = try values.decodeIfPresent(Int.self, forKey: .itag)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		mimeType = try values.decodeIfPresent(String.self, forKey: .mimeType)
		bitrate = try values.decodeIfPresent(Int.self, forKey: .bitrate)
		width = try values.decodeIfPresent(Int.self, forKey: .width)
		height = try values.decodeIfPresent(Int.self, forKey: .height)
		initRange = try values.decodeIfPresent(InitRange.self, forKey: .initRange)
		indexRange = try values.decodeIfPresent(YT_IndexRange.self, forKey: .indexRange)
		lastModified = try values.decodeIfPresent(String.self, forKey: .lastModified)
		contentLength = try values.decodeIfPresent(String.self, forKey: .contentLength)
		quality = try values.decodeIfPresent(String.self, forKey: .quality)
		fps = try values.decodeIfPresent(Int.self, forKey: .fps)
		qualityLabel = try values.decodeIfPresent(String.self, forKey: .qualityLabel)
		projectionType = try values.decodeIfPresent(String.self, forKey: .projectionType)
		averageBitrate = try values.decodeIfPresent(Int.self, forKey: .averageBitrate)
		approxDurationMs = try values.decodeIfPresent(String.self, forKey: .approxDurationMs)
	}

}
