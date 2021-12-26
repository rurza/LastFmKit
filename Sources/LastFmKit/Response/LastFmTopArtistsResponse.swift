//
//  LastFmTopArtistsResponse.swift
//  
//
//  Created by Adam on 26/12/2021.
//

import Foundation

public struct LastFmTopArtistsResponse: Codable {
    public let artists: [LastFmArtist]
    public let totalPages: Int?
    public let page: Int?
    public let perPage: Int?
    public let total: Int?
    public let user: String
    
    public init(artists: [LastFmArtist], totalPages: Int?, page: Int?, perPage: Int?, total: Int?, user: String) {
        self.artists = artists
        self.totalPages = totalPages
        self.page = page
        self.perPage = perPage
        self.total = total
        self.user = user
    }
}

extension LastFmTopArtistsResponse {
    enum CodingKeys: String, CodingKey {
        case totalPages
        case page
        case perPage
        case total
        case user
        case artists = "artist"
        case attributes = "@attr"
        case topArtists = "topartists"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topArtists)
        artists = try nestedContainer.decode([LastFmArtist].self, forKey: .artists)
        let attributes = try nestedContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        user = try attributes.decode(String.self, forKey: .user)
        totalPages = Int(try attributes.decode(String.self, forKey: .totalPages))
        page = Int(try attributes.decode(String.self, forKey: .page))
        perPage = Int(try attributes.decode(String.self, forKey: .perPage))
        total = Int(try attributes.decode(String.self, forKey: .total))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topArtists)
        try nestedContainer.encode(artists, forKey: .artists)
        var attributes = nestedContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try attributes.encode(totalPages?.description, forKey: .totalPages)
        try attributes.encode(page?.description, forKey: .page)
        try attributes.encode(perPage?.description, forKey: .perPage)
        try attributes.encode(total?.description, forKey: .total)
        try attributes.encode(user, forKey: .user)
    }
}
