//
//  LastfmUserGetInfoResponseTests.swift
//  
//
//  Created by Adam Różyński on 14/05/2021.
//

@testable import LastFmKit
import XCTest

final class LastfmUserGetInfoResponseTests: XCTestCase {
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    func testUserInfoMarshalling() throws {
        let response = try decoder.decode(LastFmUserInfo.self, from: Data.dataFrom(.userInfoResponse))
        let data = try encoder.encode(response)
        let backResponse = try decoder.decode(LastFmUserInfo.self, from: data)
        XCTAssertEqual(backResponse, response)
    }
}
