//
//  TrendingModel.swift
//  Qmusic
//
//  Created by Macbook on 9/28/23.
//

import Foundation

struct TrendingModel : Codable {
    let reqID : String?
    let result : Trending_Result?

    enum CodingKeys: String, CodingKey {

        case reqID = "reqID"
        case result = "result"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reqID = try values.decodeIfPresent(String.self, forKey: .reqID)
        result = try values.decodeIfPresent(Trending_Result.self, forKey: .result)
    }

}

struct Trending_Result : Codable {
    let code : Int?
    let message : String?
    let langCode : String?
    let isCache : Bool?
    let data : Trending_DataResult?

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
        data = try values.decodeIfPresent(Trending_DataResult.self, forKey: .data)
    }

}

struct Trending_DataResult : Codable {
    let status : Bool?
    let tracks : Trending_Data_Tracks?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case tracks = "tracks"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        tracks = try values.decodeIfPresent(Trending_Data_Tracks.self, forKey: .tracks)
    }

}
struct Trending_Data_Tracks : Codable {
    let totalCount : Int?
    let items : [Trending_TrackItems]?

    enum CodingKeys: String, CodingKey {

        case totalCount = "totalCount"
        case items = "items"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
        items = try values.decodeIfPresent([Trending_TrackItems].self, forKey: .items)
    }

}
struct Trending_TrackItems : Codable {
    let type : String?
    let id : String?
    let name : String?
    let shareUrl : String?
    let durationMs : Int?
    let durationText : String?
    let discNumber : Int?
    let trackNumber : Int?
    let playCount : Int?
    let imageSong : String?
    let artists : [Trending_TracksArtists]?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case id = "id"
        case name = "name"
        case shareUrl = "shareUrl"
        case durationMs = "durationMs"
        case durationText = "durationText"
        case discNumber = "discNumber"
        case trackNumber = "trackNumber"
        case playCount = "playCount"
        case imageSong = "imageSong"
        case artists = "artists"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        shareUrl = try values.decodeIfPresent(String.self, forKey: .shareUrl)
        durationMs = try values.decodeIfPresent(Int.self, forKey: .durationMs)
        durationText = try values.decodeIfPresent(String.self, forKey: .durationText)
        discNumber = try values.decodeIfPresent(Int.self, forKey: .discNumber)
        trackNumber = try values.decodeIfPresent(Int.self, forKey: .trackNumber)
        playCount = try values.decodeIfPresent(Int.self, forKey: .playCount)
        imageSong = try values.decodeIfPresent(String.self, forKey: .imageSong)
        artists = try values.decodeIfPresent([Trending_TracksArtists].self, forKey: .artists)
    }
}

struct Trending_TracksArtists : Codable {
    let type : String?
    let id : String?
    let name : String?
    let shareUrl : String?

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case id = "id"
        case name = "name"
        case shareUrl = "shareUrl"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        shareUrl = try values.decodeIfPresent(String.self, forKey: .shareUrl)
    }

}
