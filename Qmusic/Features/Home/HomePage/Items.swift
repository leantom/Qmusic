/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
extension HomePage {
    struct Items : Codable {
        let type : String?
        let id : String?
        let name : String?
        let shareUrl : String?
        let description : String?
        let trackCount : Int?
        let owner : Owner?
        let images : [[Images]]?

        enum CodingKeys: String, CodingKey {

            case type = "type"
            case id = "id"
            case name = "name"
            case shareUrl = "shareUrl"
            case description = "description"
            case trackCount = "trackCount"
            case owner = "owner"
            case images = "images"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            type = try values.decodeIfPresent(String.self, forKey: .type)
            id = try values.decodeIfPresent(String.self, forKey: .id)
            name = try values.decodeIfPresent(String.self, forKey: .name)
            shareUrl = try values.decodeIfPresent(String.self, forKey: .shareUrl)
            description = try values.decodeIfPresent(String.self, forKey: .description)
            trackCount = 0
            owner = try values.decodeIfPresent(Owner.self, forKey: .owner)
            images = try values.decodeIfPresent([[Images]].self, forKey: .images)
        }

    }
}

