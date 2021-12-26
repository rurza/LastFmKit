//
//  LastFmArtist.swift
//
//  Created by Adam Różyński on 04/10/2021.
//

import Foundation

public struct LastFmArtist: Codable, Equatable {
    public let url: URL
    public let name: String
    public let images: [LastFmImage]?
    public let mbid: String
    public let playcount: Int?

    enum CodingKeys: String, CodingKey {
        case url
        case name
        case mbid
        case playcount
        case images = "image"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url)
        name = try container.decode(String.self, forKey: .name)
        mbid = try container.decode(String.self, forKey: .mbid)
        images = try container.decodeIfPresent([LastFmImage].self, forKey: .images)
        if let playcountString = try container.decodeIfPresent(String.self, forKey: .playcount), let playcount = Int(playcountString) {
            self.playcount = playcount
        } else {
            self.playcount = nil
        }
    }

    public init(url: URL, name: String, images: [LastFmImage]?, mbid: String, playcount: Int? = nil) {
        self.url = url
        self.name = name
        self.images = images
        self.mbid = mbid
        self.playcount = playcount
    }
}
