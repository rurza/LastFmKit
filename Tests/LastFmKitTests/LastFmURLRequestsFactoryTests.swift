//
//  LastFmURLRequestsFactoryTests.swift
//  
//
//  Created by Adam Różyński on 28/04/2021.
//

@testable import LastFmKit
import XCTest

final class LastFmURLRequestsFactoryTests: XCTestCase {
    
    func testCommonURLComponents() throws {
        let components = LastFmURLRequestsFactory.commonComponents()
        XCTAssertEqual(components.scheme, "https")
        XCTAssertEqual(components.host, "ws.audioscrobbler.com")
        XCTAssertEqual(components.path, "/2.0/")
        XCTAssertNotNil(components.url)
        XCTAssertNil(components.queryItems)
    }
    
    func testSortingQueryItems() throws {
        let zItem = URLQueryItem(name: "z", value: "1")
        let aItem = URLQueryItem(name: "a", value: "2")
        let queryItems = [zItem,
                          aItem,
                          URLQueryItem(name: "y", value: "3"),
                          URLQueryItem(name: "b", value: "4")]
        let sortedQueryItems = LastFmURLRequestsFactory.sortedParams(for: queryItems)
        XCTAssertEqual(sortedQueryItems.first, aItem)
        XCTAssertEqual(sortedQueryItems.last, zItem)
    }
    
    func testMethodSignatureHash() throws {
        let zItem = URLQueryItem(name: "z", value: "1")
        let aItem = URLQueryItem(name: "a", value: "2")
        let queryItems = [zItem, aItem]
        let hash = LastFmURLRequestsFactory.methodSignature(for: queryItems, secret: "secret")
        XCTAssertEqual(hash, "fc5b09f18a8835aa2a2ca4b0bfd11644")
    }
    
    func testPropAndMver() throws {
        var components = LastFmURLRequestsFactory.commonComponents()
        let zItem = URLQueryItem(name: "z", value: "1")
        let aItem = URLQueryItem(name: "a", value: "2")
        components.queryItems = [zItem, aItem]
        let bItem = URLQueryItem(name: "b", value: "3")
        mver(prop(\.queryItems!), { $0.append(bItem) })(&components)
    }
}
