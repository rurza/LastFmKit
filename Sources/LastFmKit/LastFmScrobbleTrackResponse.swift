//
//  LastFmScrobbleTrackResponse.swift
//  
//
//  Created by Adam Różyński on 03/05/2021.
//

import Foundation

public struct LastFmScrobbleTrackResponse: Codable {
    
    public let artist: Correction
    public let albumArtist: Correction
    public let album: Correction
    public let track: Correction
    public let scrobbleDate: Date?
    
    public struct Correction: Codable {
        public let isCorrected: Bool
        public let value: String
    }


}

extension LastFmScrobbleTrackResponse {
    
    enum CodingKeys: CodingKey {
        case artist
        case albumArtist
        case album
        case track
        case timestamp
        case scrobbles
        case scrobble
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let scrobbles = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .scrobbles)
        let scrobble = try scrobbles.nestedContainer(keyedBy: CodingKeys.self, forKey: .scrobble)
        artist = try scrobble.decode(Correction.self, forKey: .artist)
        albumArtist = try scrobble.decode(Correction.self, forKey: .albumArtist)
        album = try scrobble.decode(Correction.self, forKey: .album)
        track = try scrobble.decode(Correction.self, forKey: .track)
        let timestampString = try scrobble.decode(String.self, forKey: .timestamp)
        if let timestamp = TimeInterval(timestampString) {
            scrobbleDate = Date(timeIntervalSince1970: timestamp)
        } else {
            scrobbleDate = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var scrobblesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .scrobbles)
        var scrobbleContainer = scrobblesContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .scrobble)
        try scrobbleContainer.encode(artist, forKey: .artist)
        try scrobbleContainer.encode(album, forKey: .album)
        try scrobbleContainer.encode(albumArtist, forKey: .albumArtist)
        try scrobbleContainer.encode(track, forKey: .track)
        // notice String
        if let date = scrobbleDate {
            try scrobbleContainer.encode("\(date.timeIntervalSince1970)", forKey: .timestamp)
        } else {
            // to silence the compiler
            let nilString: String? = nil
            try scrobbleContainer.encode(nilString, forKey: .timestamp)
        }
    }
    
}

extension LastFmScrobbleTrackResponse.Correction {
    
    enum CodingKeys: String, CodingKey {
        case corrected
        case text = "#text"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // soemtimes the API doesn't return the key at all
        do {
            value = try container.decode(String.self, forKey: .text)
        } catch {
            value = ""
        }
        let correctionString = try container.decode(String.self, forKey: .corrected)
        if let value = Int(correctionString) {
            isCorrected = value > 0
        } else {
            isCorrected = false
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .text)
        try container.encode(isCorrected ? "1" : "0", forKey: .corrected)
    }

}
