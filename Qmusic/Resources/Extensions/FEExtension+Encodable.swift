//
//  FEExtension+Encodable.swift
//  FEMobile
//
//  Created by Anh Thi on 3/5/21.
//

import Foundation
public class Serializer{
    static func save<T>(data: T, to url: URL) where T : Encodable{
        guard let json = data.toJsonString else { return }
        
        do {
            try json.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        }
        catch { /* error handling here */ }
    }
    
    static func load<T>(from url: URL) throws -> T? where T : Decodable {
        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601 // for human-read date format
        
        guard let dataStr = try? String(contentsOf: url, encoding: String.Encoding.utf8 ),
              let data = dataStr.data(using: String.Encoding.utf8 ),
              let result = try? decoder.decode( T.self , from: data)
        else { return nil }
        
        return result
    }
}

extension Encodable {
    var toJsonString: String? {
        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted  // nice formatted for reading by human
//        encoder.dateEncodingStrategy = .iso8601    // for human-read date format
        
        do {
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
