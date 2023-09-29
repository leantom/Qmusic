//
//  CommentModel.swift
//  Qmusic
//
//  Created by QuangHo on 18/09/2023.
//

import Foundation
extension Response {
    struct CommentModelWrapper: Codable {
        let reqID : String?
        let result : CommentWrapperResult?

        enum CodingKeys: String, CodingKey {

            case reqID = "reqID"
            case result = "result"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            reqID = try values.decodeIfPresent(String.self, forKey: .reqID)
            result = try values.decodeIfPresent(CommentWrapperResult.self, forKey: .result)
        }
    }
    
    struct CommentWrapperResult : Codable {
        let code : Int?
        let message : String?
        let langCode : String?
        let isCache : Bool?
        let data : [CommentModel]?

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
            data = try values.decodeIfPresent([CommentModel].self, forKey: .data)
        }

    }

    
    
}
struct CommentModel: Codable {
    /**
     
     "id": 117,
                    "songId": "",
                    "userId": 8,
                    "name": "",
                    "comment": "\"Bài hát \\\"Vaicaunoicokhiennguoithaydoi\\\" của GREY D thể hiện một thông điệp mạnh mẽ về sự thay đổi và tác động của lời nói vào con người\"",
                    "likeComment": 0,
                    "createAt": "2023-09-14T18:24:11Z"
    **/
    
    let id: Int?
    let songId: String?
    
    let userId: Int?
    let name: String?
    
    let comment: String?
    let likeComment: Int?
    let createAt: String?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case songId = "songId"
        case userId = "userId"
        case name = "name"
        case comment = "comment"
        
        case likeComment = "likeComment"
        case createAt = "createAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        songId = try values.decodeIfPresent(String.self, forKey: .songId)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        
        likeComment = try values.decodeIfPresent(Int.self, forKey: .likeComment)
        createAt = try values.decodeIfPresent(String.self, forKey: .createAt)
        
    }
    
    
}
