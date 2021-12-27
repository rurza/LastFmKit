//
//  LastFmLovedTracksResponseTests.swift
//  
//
//  Created by Adam Różyński on 27/12/2021.
//

import Foundation
@testable import LastFmKit
import XCTest

final class LastFmLovedTracksResponseTests: XCTestCase {
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    func testDecoding() throws {
        let data = Data.dataFrom(.lovedTracksResponse)
        let response = try decoder.decode(LastFmLovedTracksResponse.self, from: data)
        XCTAssertEqual(response.user, "rurzynski")
        XCTAssertEqual(response.total, 1533)
        XCTAssertEqual(response.totalPages, 31)
        XCTAssertEqual(response.page, 1)
        XCTAssertEqual(response.perPage, 50)
        XCTAssertEqual(response.tracks.count, 50)
        let firstTrack = response.tracks.first
        XCTAssertEqual(firstTrack?.title, "Sea Foam")
        XCTAssertEqual(firstTrack?.date, Date(timeIntervalSince1970: 1639566010))
        XCTAssertNil(firstTrack?.mbid)
        XCTAssertNotNil(firstTrack?.artist)
        XCTAssertNil(firstTrack?.artist?.mbid)
    }

    func testEncoding() throws {
        let data = Data.dataFrom(.lovedTracksResponse)
        let response = try decoder.decode(LastFmLovedTracksResponse.self, from: data)
        let encoder = JSONEncoder()
        let encodedResponse = try encoder.encode(response)
        let response2 = try decoder.decode(LastFmLovedTracksResponse.self, from: encodedResponse)
        XCTAssertEqual(response, response2)
    }
}
