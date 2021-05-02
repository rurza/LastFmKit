//
//  LastFmErrorTests.swift
//  
//
//  Created by Adam Różyński on 02/05/2021.
//

@testable import LastFmKit
import XCTest

final class LastFmErrorTests: XCTestCase {
    
    func testErrorMarshalling() throws {
        let error = try responseMock(for: .errorResponse, expectedType: LastFmError.self)
        XCTAssertNotNil(error.error)
        XCTAssertEqual(error.error, .authenticationFailedOrUsePost)
        XCTAssertEqual(error.message, "Authentication Failed - You do not have permissions to access the service")
    }
    
    func testErrorWithNotSupportedCode() throws {
        let error = try responseMock(for: .errorWithUnknownCodeResponse, expectedType: LastFmError.self)
        XCTAssertNil(error.error)
        XCTAssertEqual(error.message, "Unknwon error that won't be handled")
    }
    
}
