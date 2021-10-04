//
//  LastFmArtist.swift
//
//  Created by Adam Różyński on 04/10/2021.
//

import Foundation

public struct LastFmArtist: Codable {
    public let url: URL
    public let name: String
    public let images: [LastFmImage]
    public let mbid: String

    enum CodingKeys: String, CodingKey {
        case url
        case name
        case mbid
        case images = "image"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url)
        name = try container.decode(String.self, forKey: .name)
        mbid = try container.decode(String.self, forKey: .mbid)
        images = try container.decode([LastFmImage].self, forKey: .images)
    }
}