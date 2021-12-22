//
//  LastFmRecentTracksResponse.swift
//
//  Created by Adam Różyński on 04/10/2021.
//

import Foundation

public struct LastFmRecentTracksResponse: Codable, Equatable {
    public let page: Int?
    public let perPage: Int?
    public let total: Int?
    public let totalPages: Int?
    public let user: String
    public let tracks: [LastFmTrack]

    enum CodingKeys: String, CodingKey {
        case page
        case perPage
        case user
        case total
        case totalPages
        case tracks = "track"
        case recentTracks = "recenttracks"
        case attributes = "@attr"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .recentTracks)
        let attributes = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        page = Int(try attributes.decode(String.self, forKey: .page))
        perPage = Int(try attributes.decode(String.self, forKey: .perPage))
        total = Int(try attributes.decode(String.self, forKey: .total))
        totalPages = Int(try attributes.decode(String.self, forKey: .totalPages))
        user = try attributes.decode(String.self, forKey: .user)
        tracks = try container.decode([LastFmTrack].self, forKey: .tracks)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var recentTracksContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .recentTracks)
        var attributesContainer = recentTracksContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        if let page = page {
            try attributesContainer.encode("\(page)", forKey: .page)
        }
        if let perPage = perPage {
            try attributesContainer.encode("\(perPage)", forKey: .perPage)
        }
        if let total = total {
            try attributesContainer.encode("\(total)", forKey: .total)
        }
        if let totalPages = totalPages {
            try attributesContainer.encode("\(totalPages)", forKey: .totalPages)
        }
        try attributesContainer.encode(user, forKey: .user)
        try recentTracksContainer.encode(tracks, forKey: .tracks)
    }
}
