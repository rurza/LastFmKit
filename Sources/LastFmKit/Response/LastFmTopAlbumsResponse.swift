//
//  LastFmTopAlbumsResponse.swift
//  
//
//  Created by Adam Różyński on 22/12/2021.
//

import Foundation

public struct LastFmTopAlbumsResponse: Codable, Equatable {
    public let albums: [LastFmTopAlbum]
    public let user: String
    public let totalPages: Int?
    public let page: Int?
    public let perPage: Int?
    public let total: Int?

    public init(albums: [LastFmTopAlbum], user: String, totalPages: Int?, page: Int?, perPage: Int?, total: Int?) {
        self.albums = albums
        self.user = user
        self.totalPages = totalPages
        self.page = page
        self.perPage = perPage
        self.total = total
    }
}

extension LastFmTopAlbumsResponse {
    enum CodingKeys: String, CodingKey {
        case albums = "album"
        case user
        case totalPages
        case page
        case perPage
        case total
        case attributes = "@attr"
        case topAlbums = "topalbums"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topAlbums)
        let attributes = try nestedContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        user = try attributes.decode(String.self, forKey: .user)
        totalPages = Int(try attributes.decode(String.self, forKey: .totalPages))
        page = Int(try attributes.decode(String.self, forKey: .page))
        perPage = Int(try attributes.decode(String.self, forKey: .perPage))
        total = Int(try attributes.decode(String.self, forKey: .total))
        albums = try nestedContainer.decode([LastFmTopAlbum].self, forKey: .albums)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topAlbums)
        try nestedContainer.encode(albums, forKey: .albums)
        var attributes = nestedContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try attributes.encode(user, forKey: .user)
        try attributes.encodeIfPresent(totalPages?.description, forKey: .totalPages)
        try attributes.encodeIfPresent(page?.description, forKey: .page)
        try attributes.encodeIfPresent(perPage?.description, forKey: .perPage)
        try attributes.encodeIfPresent(total?.description, forKey: .total)
    }
}
