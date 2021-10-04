//
//  LastFmRecentTracksResponseTests.swift
//
//  Created by Adam Różyński on 04/10/2021.
//

@testable import LastFmKit
import XCTest

final class LastFmRecentTracksResponseTests: XCTestCase {
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    func testResponseDecoding() throws {
        let data = Data.dataFrom(.extendedRecentTracksResponse)
        let response = try decoder.decode(LastFmRecentTracksResponse.self, from: data)
        XCTAssertEqual(response.tracks.first?.date, Date(timeIntervalSince1970: 1633127656))
    }
}
