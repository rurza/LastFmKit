//
//  LastFmSimilarArtistsResponseTests.swift
//  
//
//  Created by Adam Różyński on 22/12/2021.
//

import XCTest
@testable import LastFmKit

final class LastFmSimilarArtistsResponseTests: XCTestCase {

    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    func testDecoding() throws {
        let data = Data.dataFrom(.similarArtistsResponse)
        let similarArtists = try decoder.decode(LastFmSimilarArtistsResponse.self, from: data)
        XCTAssertEqual(similarArtists.artist, "Cher")
        XCTAssertEqual(similarArtists.artists.count, 100)
    }
}
