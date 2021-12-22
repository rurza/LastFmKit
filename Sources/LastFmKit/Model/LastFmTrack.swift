//
//  LastFmTrack.swift
//
//  Created by Adam Różyński on 04/10/2021.
//

import Foundation

public struct LastFmTrack: Codable, Equatable {
    public let name: String
    public let url: URL
    public let mbid: String?
    public let isStreamable: Bool?
    public let isLoved: Bool?
    public let date: Date?
    public let images: [LastFmImage]?
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
        mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
        if let streamInt = Int(try container.decode(String.self, forKey: .isStreamable)) {
            isStreamable = streamInt != 0
        } else {
            isStreamable = nil
        }
        if let lovedString = try container.decodeIfPresent(String.self, forKey: .isLoved), let lovedInt = Int(lovedString) {
            isLoved = lovedInt != 0
        } else {
            isLoved = nil
        }
        // ie track isn't scrobbled yet but has "now playing" status
        if container.contains(.date) {
            let dateContainer = try container.nestedContainer(keyedBy: DateKeys.self, forKey: .date)
            if let stringDate = try dateContainer.decodeIfPresent(String.self, forKey: .date), let dateDouble = TimeInterval(stringDate) {
                date = Date(timeIntervalSince1970: dateDouble)
            } else {
                date = nil
            }
        } else {
            date = nil
        }
        do {
            images = try container.decodeIfPresent([LastFmImage].self, forKey: .images)
        } catch {
            images = nil
        }
        artist = try container.decode(LastFmArtist.self, forKey: .artist)
        album = try container.decode(LastFmAlbum.self, forKey: .album)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
        try container.encode(mbid, forKey: .mbid)
        if let isStreamable = isStreamable {
            try container.encode("\(isStreamable ? 1 : 0)", forKey: .isStreamable)
        }
        if let isLoved = isLoved {
            try container.encode("\(isLoved ? 1 : 0)", forKey: .isLoved)
        }
        if let date = date {
            var dateContainer = container.nestedContainer(keyedBy: DateKeys.self, forKey: .date)
            try dateContainer.encode("\(date.timeIntervalSince1970)", forKey: .date)
        }
        try container.encode(images, forKey: .images)
        try container.encode(artist, forKey: .artist)
        try container.encode(album, forKey: .album)
    }
}
