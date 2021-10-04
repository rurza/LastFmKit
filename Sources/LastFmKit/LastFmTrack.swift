//
//  LastFmTrack.swift
//
//  Created by Adam Różyński on 04/10/2021.
//

import Foundation

public struct LastFmTrack: Codable {
    public let name: String
    public let url: URL
    public let mbid: String
    public let isStreamable: Bool?
    public let isLoved: Bool?
    public let date: Date?
    public let images: [LastFmImage]
    public let artist: LastFmArtist
    public let album: LastFmAlbum

    enum CodingKeys: String, CodingKey {
        case name
        case url
        case isStreamable = "streamable"
        case date
        case images = "image"
        case artist
        case album
        case isLoved = "loved"
        case mbid
    }

    enum DateKeys: String, CodingKey {
        case date = "uts"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(URL.self, forKey: .url)
        mbid = try container.decode(String.self, forKey: .mbid)
        if let streamInt = Int(try container.decode(String.self, forKey: .isStreamable)) {
            isStreamable = streamInt != 0
        } else {
            isStreamable = nil
        }
        if let lovedInt = Int(try container.decode(String.self, forKey: .isLoved)) {
            isLoved = lovedInt != 0
        } else {
            isLoved = nil
        }
        let dateContainer = try container.nestedContainer(keyedBy: DateKeys.self, forKey: .date)
        if let dateDouble = TimeInterval(try dateContainer.decode(String.self, forKey: .date)) {
            date = Date(timeIntervalSince1970: dateDouble)
        } else {
            date = nil
        }
        images = try container.decode([LastFmImage].self, forKey: .images)
        artist = try container.decode(LastFmArtist.self, forKey: .artist)
        album = try container.decode(LastFmAlbum.self, forKey: .album)
    }

    public func encode(to encoder: Encoder) throws {
        #warning("implement")
    }
}
