//
//  LastFmUserInfo.swift
//  
//
//  Created by Adam Różyński on 13/05/2021.
//

import Foundation

public struct LastFmUserInfo: Codable, Equatable {
    public var playlists: UInt?
    public let playCount: UInt
    public let name: String
    public let url: URL
    public let country: String
    public let subscriber: Bool
    public var realName: String?
    public var images: [LastFmImage]?
    public let registeredDate: Date
}

extension LastFmUserInfo {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let user = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
        if let playlists = UInt(try user.decode(String.self, forKey: .playlists)) {
            self.playlists = playlists
        } else {
            playlists = nil
        }
        if let playCount = UInt(try user.decode(String.self, forKey: .playCount)) {
            self.playCount = playCount
        } else {
            playCount = 0
        }
        name = try user.decode(String.self, forKey: .name)
        url = try user.decode(URL.self, forKey: .url)
        country = try user.decode(String.self, forKey: .country)
        if let subscriber = UInt(try user.decode(String.self, forKey: .subscriber)) {
            self.subscriber = subscriber > 0
        } else {
            subscriber = false
        }
        realName = try user.decodeIfPresent(String.self, forKey: .realName)
        let registered = try user.nestedContainer(keyedBy: CodingKeys.self, forKey: .registeredDate)
        registeredDate = try registered.decode(Date.self, forKey: .text)
        images = try user.decodeIfPresent([LastFmImage].self, forKey: .images)
    }
    
    public func encode(to encoder: Encoder) throws {
        var rootContainer = encoder.container(keyedBy: CodingKeys.self)
        var user = rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
        let playlists = playlists != nil ? String(playlists!) : nil
        try user.encode(playlists, forKey: .playlists)
        try user.encode("\(playCount)", forKey: .playCount)
        try user.encode(name, forKey: .name)
        try user.encode(url, forKey: .url)
        try user.encode(country, forKey: .country)
        try user.encode(subscriber ? "1" : "0", forKey: .subscriber)
        try user.encode(realName, forKey: .realName)
        try user.encode(images, forKey: .images)
        var date = user.nestedContainer(keyedBy: CodingKeys.self, forKey: .registeredDate)
        try date.encode(registeredDate, forKey: .text)
    }
    
    enum CodingKeys: String, CodingKey {
        case playlists
        case playCount = "playcount"
        case realName = "realname"
        case name
        case url
        case country
        case images = "image"
        case registeredDate = "registered"
        case subscriber
        case user
        case text = "#text" // the LastFm api returns a Double for this key, the second key "unixtime" returns String
    }
    
}
