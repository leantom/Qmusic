/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Discography : Codable {
	let latest : Latest?
	let singles : Singles?
    let albums : ArtistModel.Albums?
	let compilations : Compilations?
	let popularReleasesAlbums : [PopularReleasesAlbums]?
	let topTracks : [TopTracks]?

	enum CodingKeys: String, CodingKey {

		case latest = "latest"
		case singles = "singles"
		case albums = "albums"
		case compilations = "compilations"
		case popularReleasesAlbums = "popularReleasesAlbums"
		case topTracks = "topTracks"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		latest = try values.decodeIfPresent(Latest.self, forKey: .latest)
		singles = try values.decodeIfPresent(Singles.self, forKey: .singles)
        albums = try values.decodeIfPresent(ArtistModel.Albums.self, forKey: .albums)
		compilations = try values.decodeIfPresent(Compilations.self, forKey: .compilations)
		popularReleasesAlbums = try values.decodeIfPresent([PopularReleasesAlbums].self, forKey: .popularReleasesAlbums)
		topTracks = try values.decodeIfPresent([TopTracks].self, forKey: .topTracks)
	}

}
