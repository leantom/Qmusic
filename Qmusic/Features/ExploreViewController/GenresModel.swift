
import Foundation
extension Response {
    struct GenresWrapper : Codable {
        let reqID : String?
        let result : GenresResult?

        enum CodingKeys: String, CodingKey {

            case reqID = "reqID"
            case result = "result"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            reqID = try values.decodeIfPresent(String.self, forKey: .reqID)
            result = try values.decodeIfPresent(GenresResult.self, forKey: .result)
        }

    }

}

struct GenresResult : Codable {
    let code : Int?
    let message : String?
    let langCode : String?
    let isCache : Bool?
    let data : GenresDetail?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case langCode = "langCode"
        case isCache = "isCache"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        langCode = try values.decodeIfPresent(String.self, forKey: .langCode)
        isCache = try values.decodeIfPresent(Bool.self, forKey: .isCache)
        data = try values.decodeIfPresent(GenresDetail.self, forKey: .data)
    }

}


struct GenresDetail : Codable {
    let status : Bool?
    let type : String?
    let id : String?
    let name : String?
    let shareUrl : String?
    let contents : GenresModel.Contents?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case type = "type"
        case id = "id"
        case name = "name"
        case shareUrl = "shareUrl"
        case contents = "contents"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        shareUrl = try values.decodeIfPresent(String.self, forKey: .shareUrl)
        contents = try values.decodeIfPresent(GenresModel.Contents.self, forKey: .contents)
    }

}

extension GenresModel {
    struct Contents : Codable {
        let totalCount : Int?
        let items : [GenresModel.Items]?

        enum CodingKeys: String, CodingKey {

            case totalCount = "totalCount"
            case items = "items"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
            items = try values.decodeIfPresent([GenresModel.Items].self, forKey: .items)
        }

    }
}

struct GenresModel {
    
    struct Items : Codable {
        let type : String?
        let id : String?
        let name : String?
        let shareUrl : String?
        let contents : GenresModel.SubContents?

        enum CodingKeys: String, CodingKey {

            case type = "type"
            case id = "id"
            case name = "name"
            case shareUrl = "shareUrl"
            case contents = "contents"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            type = try values.decodeIfPresent(String.self, forKey: .type)
            id = try values.decodeIfPresent(String.self, forKey: .id)
            name = try values.decodeIfPresent(String.self, forKey: .name)
            shareUrl = try values.decodeIfPresent(String.self, forKey: .shareUrl)
            contents = try values.decodeIfPresent(GenresModel.SubContents.self, forKey: .contents)
        }

    }
    
    struct SubContents : Codable {
        let totalCount : Int?
        let items : [PlaylistItems]?

        enum CodingKeys: String, CodingKey {

            case totalCount = "totalCount"
            case items = "items"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
            items = try values.decodeIfPresent([PlaylistItems].self, forKey: .items)
        }

    }
    
    
    struct PlaylistItems : Codable {
        let type : String?
        let id : String?
        let name : String?
        let shareUrl : String?
        let description : String?
        let trackCount : Int?
        let owner : HomePage.Owner?
        let images : [[HomePage.Images]]?

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
            trackCount = try values.decodeIfPresent(Int.self, forKey: .trackCount)
            owner = try values.decodeIfPresent(HomePage.Owner.self, forKey: .owner)
            images = try values.decodeIfPresent([[HomePage.Images]].self, forKey: .images)
        }

    }
    
}
