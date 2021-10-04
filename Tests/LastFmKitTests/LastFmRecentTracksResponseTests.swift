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

    let encoder = JSONEncoder()

    func testResponseDecoding() throws {
        let data = Data.dataFrom(.extendedRecentTracksResponse)
        let response = try decoder.decode(LastFmRecentTracksResponse.self, from: data)
        XCTAssertEqual(response.tracks.first?.date, Date(timeIntervalSince1970: 1633127656))
    }

    func testResponseEncoding() throws {
        let data = Data.dataFrom(.extendedRecentTracksResponse)
        let response = try decoder.decode(LastFmRecentTracksResponse.self, from: data)
        let encodeBack = try encoder.encode(response)
        let response2 = try decoder.decode(LastFmRecentTracksResponse.self, from: encodeBack)
        XCTAssertEqual(response2.perPage, response.perPage)
        XCTAssertEqual(response2.page, response.page)
        XCTAssertEqual(response2.total, response.total)
        XCTAssertEqual(response2.user, response.user)
        XCTAssertEqual(response2.tracks.count, response.tracks.count)
        XCTAssertEqual(response2.tracks.first?.date, response.tracks.first?.date)
        XCTAssertEqual(response2.tracks.last?.date, response.tracks.last?.date)
        XCTAssertEqual(response2.tracks.last?.isLoved, response.tracks.last?.isLoved)
    }
}
