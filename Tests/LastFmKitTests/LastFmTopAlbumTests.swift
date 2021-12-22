//
//  LastFmTopAlbumTests.swift
//  
//
//  Created by Adam Różyński on 22/12/2021.
//

import XCTest
@testable import LastFmKit

final class LastFmTopAlbumTests: XCTestCase {

    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    func testDecoding() throws {
        let data = Data.dataFrom(.topAlbum)
        let album = try decoder.decode(LastFmTopAlbum.self, from: data)
        XCTAssertEqual(album.artist?.name, "Massive Attack")
        XCTAssertEqual(album.playcount, 3772)
        XCTAssertEqual(album.rank, 1)
    }
}
