//
//  LastFmPeriodTests.swift
//  
//
//  Created by Adam Różyński on 22/12/2021.
//

import XCTest
@testable import LastFmKit

final class LastFmPeriodTests: XCTestCase {
    func testRawValues() throws {
        XCTAssertEqual(LastFmPeriod.overall.rawValue, "overall")
        XCTAssertEqual(LastFmPeriod.week.rawValue, "7day")
        XCTAssertEqual(LastFmPeriod.month.rawValue, "1month")
        XCTAssertEqual(LastFmPeriod.quarter.rawValue, "3month")
        XCTAssertEqual(LastFmPeriod.halfYear.rawValue, "6month")
        XCTAssertEqual(LastFmPeriod.year.rawValue, "12month")
    }
}
