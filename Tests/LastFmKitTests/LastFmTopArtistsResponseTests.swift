//
//  LastFmTopArtistsResponseTests.swift
//  
//
//  Created by Adam on 27/12/2021.
//

import Foundation
import XCTest
@testable import LastFmKit

final class LastFmTopArtistsResponseTests: XCTestCase {
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    func testDecoding() throws {
        let data = Data.dataFrom(.topArtistsResponse)
        let response = try decoder.decode(LastFmTopArtistsResponse.self, from: data)
        XCTAssertEqual(response.user, "rurzynski")
        XCTAssertEqual(response.total, 10274)
        XCTAssertEqual(response.totalPages, 206)
        XCTAssertEqual(response.artists.count, 50)
        XCTAssertEqual(response.artists.first?.images?.count, 5)
        XCTAssertEqual(response.artists.first?.name, "Tool")
        XCTAssertEqual(response.artists.first?.playcount, 9243)
    }
}
