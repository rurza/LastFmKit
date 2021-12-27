//
//  LastFmTopAlbum.swift
//  
//
//  Created by Adam Różyński on 22/12/2021.
//

import Foundation

public struct LastFmTopAlbum: Codable, Equatable {
    public let artist: LastFmArtist?
    public let images: [LastFmImage]?
    public let mbid: String?
    public let url: URL?
    public let name: String
    public let playcount: Int?
    public let rank: Int?

    public init(artist: LastFmArtist?, images: [LastFmImage]?, mbid: String?, url: URL?, name: String, playcount: Int?, rank: Int?) {
        self.artist = artist
        self.images = images
        self.mbid = mbid
        self.url = url
        self.name = name
        self.playcount = playcount
        self.rank = rank
    }
}

extension LastFmTopAlbum {
    enum CodingKeys: String, CodingKey {
        case artist
        case images = "image"
        case mbid
        case url
        case name
        case playcount
        case rank
        case attributes = "@attr"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let attributes = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        let rankString = try attributes.decode(String.self, forKey: .rank)
        rank = Int(rankString)
        let playcountString = try container.decode(String.self, forKey: .playcount)
        playcount = Int(playcountString)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        if let mbid = try container.decodeIfPresent(String.self, forKey: .mbid), mbid.count > 0 {
            self.mbid = mbid
        } else {
            self.mbid = nil
        }
        do {
            images = try container.decodeIfPresent([LastFmImage].self, forKey: .images)
        } catch {
            images = nil
        }
        artist = try container.decodeIfPresent(LastFmArtist.self, forKey: .artist)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var attributes = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try attributes.encodeIfPresent(rank?.description, forKey: .rank)
        try container.encode(images, forKey: .images)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(playcount?.description, forKey: .playcount)
        try container.encode(url, forKey: .url)
        try container.encode(artist, forKey: .artist)
        try container.encode(mbid, forKey: .mbid)
    }
}
