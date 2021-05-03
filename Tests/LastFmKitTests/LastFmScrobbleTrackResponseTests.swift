//
//  LastFmScrobbleTrackResponseTests.swift
//  
//
//  Created by Adam Różyński on 03/05/2021.
//

@testable import LastFmKit
import XCTest

final class LastFmScrobbleTrackResponseTests: XCTestCase {
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    func testScrobbleMarshalling() throws {
        let response = try responseMock(for: .scrobbleResponse, expectedType: LastFmScrobbleTrackResponse.self)
        XCTAssertEqual(response.scrobbleDate?.timeIntervalSince1970, 1620057941.9559)
        XCTAssertFalse(response.artist.isCorrected)
        XCTAssertFalse(response.album.isCorrected)
        XCTAssertTrue(response.track.isCorrected)
        XCTAssertEqual(response.artist.value, "Tool")
        XCTAssertEqual(response.albumArtist.value, "Tool")
        XCTAssertEqual(response.album.value, "")
        XCTAssertEqual(response.track.value, "Ænima")
    }
    
    func testScrobbleSerialization() throws {
        let response = try responseMock(for: .scrobbleResponse, expectedType: LastFmScrobbleTrackResponse.self)
        let data = try encoder.encode(response)
        let newResponse = try decoder.decode(LastFmScrobbleTrackResponse.self, from: data)
        
//        XCTAssertEqual(response, newResponse)
    }
    
}
