//
//  LastFmSimilarArtistsReponse.swift
//  
//
//  Created by Adam Różyński on 22/12/2021.
//

import Foundation

public struct LastFmSimilarArtistsReponse: Codable, Equatable {
    public let artists: [LastFmArtist]
    public let artist: String
}

extension LastFmSimilarArtistsReponse {
    enum CodingKeys: String, CodingKey {
        case similarArtists = "similarartists"
        case artists = "artist"
        case attributes = "@attr"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let similarArtists = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .similarArtists)
        artists = try similarArtists.decode([LastFmArtist].self, forKey: .artists)
        let artistContainer = try similarArtists.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        artist = try artistContainer.decode(String.self, forKey: .artists)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var similarArtistsContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .similarArtists)
        var artistContainer = similarArtistsContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try artistContainer.encode(artist, forKey: .artists)
        try similarArtistsContainer.encode(artist, forKey: .artists)
    }
}
