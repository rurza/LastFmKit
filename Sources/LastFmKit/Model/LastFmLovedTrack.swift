//
//  LastFmLovedTrack.swift
//  
//
//  Created by Adam on 27/12/2021.
//

import Foundation

public struct LastFmLovedTrack: Codable, Equatable {
    public let title: String
    public let date: Date?
    public let url: URL?
    public let images: [LastFmImage]?
    public let mbid: String?
    public let artist: Artist?
    
    public struct Artist: Codable, Equatable {
        public let url: URL?
        public let name: String
        public let mbid: String?
    }
}

extension LastFmLovedTrack {
    enum CodingKeys: String, CodingKey {
        case date
        case mbid
        case artist
        case images = "image"
        case title = "name"
        case url
        case timeInterval = "uts"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        images = try container.decodeIfPresent([LastFmImage].self, forKey: .images)
        artist = try container.decode(Artist.self, forKey: .artist)
        if let mbid = try container.decodeIfPresent(String.self, forKey: .mbid), mbid.count > 0 {
            self.mbid = mbid
        } else {
            self.mbid = nil
        }
        let dateContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .date)
        let dateString = try dateContainer.decode(String.self, forKey: .timeInterval)
        if let dateDouble = TimeInterval(dateString) {
            date = Date(timeIntervalSince1970: dateDouble)
        } else {
            date = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var dateAttributes = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .date)
        try dateAttributes.encode("\(date?.timeIntervalSince1970 ?? 0)", forKey: .timeInterval)
        try container.encode(images, forKey: .images)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
        try container.encode(artist, forKey: .artist)
        try container.encode(mbid, forKey: .mbid)
    }
}

extension LastFmLovedTrack.Artist {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url)
        name = try container.decode(String.self, forKey: .name)
        if let mbid = try container.decodeIfPresent(String.self, forKey: .mbid), mbid.count > 0 {
            self.mbid = mbid
        } else {
            self.mbid = nil
        }
    }
}
