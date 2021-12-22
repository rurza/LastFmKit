//
//  LastFmSimilarTrack.swift
//  
//
//  Created by Adam Różyński on 22/12/2021.
//

import Foundation

public struct LastFmSimilarTrack: Codable {
    public let title: String
    public let playCount: Int
    public let url: URL?
    public let images: [LastFmImage]?
    public let mbid: String?
    public let duration: Int?
    public let artist: LastFmArtist?
}

extension LastFmSimilarTrack {
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case playCount = "playcount"
        case url
        case images = "image"
        case mbid
        case duration
        case artist
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        playCount = try container.decode(Int.self, forKey: .playCount)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        images = try container.decodeIfPresent([LastFmImage].self, forKey: .images)
        mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
        duration = try container.decodeIfPresent(Int.self, forKey: .duration)
        artist = try container.decodeIfPresent(LastFmArtist.self, forKey: .artist)
    }
}
