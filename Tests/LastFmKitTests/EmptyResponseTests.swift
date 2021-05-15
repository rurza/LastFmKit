//
//  EmptyResponseTests.swift
//  
//
//  Created by Adam Różyński on 14/05/2021.
//

@testable import LastFmKit
import XCTest

final class EmptyResponseTests: XCTestCase {
    
    func testEmptyResponseDecoding() throws {
        _ = try JSONDecoder().decode(VoidCodable.self, from: Data.dataFrom(.emptyResponse))
    }

}
