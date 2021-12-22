//
//  LastFmGetSimilarTracksResponseTests.swift
//  
//
//  Created by Adam Różyński on 22/12/2021.
//

import XCTest
@testable import LastFmKit

final class LastFmGetSimilarTracksResponseTests: XCTestCase {
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    let encoder = JSONEncoder()

    func testResponseDecoding() throws {
        let data = Data.dataFrom(.similarTracksResponse)
        let response = try decoder.decode(LastFmSimilarTracksResponse.self, from: data)
        XCTAssertEqual(response.tracks.count, 100)
        XCTAssertEqual(response.artist, "Cher")

    }

}
