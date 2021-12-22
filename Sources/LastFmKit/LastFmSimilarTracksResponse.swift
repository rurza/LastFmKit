//
//  LastFmSimilarTracksResponse.swift
//  
//
//  Created by Adam Różyński on 22/12/2021.
//

import Foundation

public struct LastFmSimilarTracksResponse: Codable {
    public let tracks: [LastFmSimilarTrack]
    public let artist: String
}

extension LastFmSimilarTracksResponse {

    enum CodingKeys: String, CodingKey {
        case similartracks
        case tracks = "track"
        case attributes = "@attr"
        case artist
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let similarTracksContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .similartracks)
        let artistContainer = try similarTracksContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        artist = try artistContainer.decode(String.self, forKey: .artist)
        tracks = try similarTracksContainer.decode([LastFmSimilarTrack].self, forKey: .tracks)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var similarTracksContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .similartracks)
        var artistContainer = similarTracksContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try artistContainer.encode(artist, forKey: .artist)
        try similarTracksContainer.encode(tracks, forKey: .tracks)
    }

}
