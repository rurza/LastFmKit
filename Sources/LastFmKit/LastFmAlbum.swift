//
//  LastFmAlbum.swift
//
//  Created by Adam Różyński on 04/10/2021.
//

import Foundation

public struct LastFmAlbum: Codable, Equatable {
    public let title: String
    public let mbid: String

    enum CodingKeys: String, CodingKey {
        case title = "#text"
        case mbid
    }
}
