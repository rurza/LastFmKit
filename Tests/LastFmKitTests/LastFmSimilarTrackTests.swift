//
//  LastFmSimilarTrackTests.swift
//  
//
//  Created by Adam Różyński on 22/12/2021.
//

import XCTest
@testable import LastFmKit

final class LastFmSimilarTrackTests: XCTestCase {
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    let encoder = JSONEncoder()

    func testDecoding() throws {
        let data = Data.dataFrom(.similarTrack)
        let track = try decoder.decode(LastFmSimilarTrack.self, from: data)
        XCTAssertEqual(track.title, "Strong Enough")
        XCTAssertEqual(track.artist?.name, "Cher")
        XCTAssertEqual(track.images?.count, 6)
    }

    func testEncoding() throws {
        let data = Data.dataFrom(.similarTrack)
        let track = try decoder.decode(LastFmSimilarTrack.self, from: data)
        let encoded = try encoder.encode(track)
        let track2 = try decoder.decode(LastFmSimilarTrack.self, from: encoded)
        XCTAssertEqual(track2, track)
    }
}
