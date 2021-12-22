//
//  LastFmTopAlbumsResponseTests.swift
//  
//
//  Created by Adam Różyński on 22/12/2021.
//

import XCTest
@testable import LastFmKit

final class LastFmTopAlbumsResponseTests: XCTestCase {

    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    let encoder = JSONEncoder()

    func testDecoding() throws {
        let data = Data.dataFrom(.topAlbumsResponse)
        let response = try decoder.decode(LastFmTopAlbumsResponse.self, from: data)
        XCTAssertEqual(response.user, "rurzynski")
    }

    func testEncoding() throws {
        let data = Data.dataFrom(.topAlbumsResponse)
        let response = try decoder.decode(LastFmTopAlbumsResponse.self, from: data)
        let encoded = try encoder.encode(response)
        let response2 = try decoder.decode(LastFmTopAlbumsResponse.self, from: encoded)
        XCTAssertEqual(response2, response)
    }
}
