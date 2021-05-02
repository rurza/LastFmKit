//
//  LastFmSession.swift
//  
//
//  Created by Adam Różyński on 01/05/2021.
//

import Foundation

public struct LastFmSession {
    let name: String
    let key: String
    let subscriber: Int
}

extension LastFmSession: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let session = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .session)
        name = try session.decode(String.self, forKey: .name)
        key = try session.decode(String.self, forKey: .key)
        subscriber = try session.decode(Int.self, forKey: .subscriber)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var session = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .session)
        try session.encode(name, forKey: .name)
        try session.encode(key, forKey: .key)
        try session.encode(subscriber, forKey: .subscriber)
    }
    
    
    enum CodingKeys: CodingKey {
        case session
        case name
        case key
        case subscriber
    }
}
