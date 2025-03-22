//
//  SocialNumberFormatterTests.swift
//  GitFeedTests
//
//  Created by Dat on 21/03/2025.
//

import XCTest
@testable import GitFeed

class SocialNumberFormatterTests: XCTestCase {
    var formatter: SocialNumberFormater!

    override func setUp() {
        super.setUp()
        formatter = SocialNumberFormater()
    }

    override func tearDown() {
        formatter = nil
        super.tearDown()
    }

    func testFormat_normalCases() {
        XCTAssertEqual(formatter.format(0), "0")
        XCTAssertEqual(formatter.format(5), "5")
        XCTAssertEqual(formatter.format(10), "10")
        XCTAssertEqual(formatter.format(999), "999")
        XCTAssertEqual(formatter.format(1000), "1K")
        XCTAssertEqual(formatter.format(1500), "1K+")
        XCTAssertEqual(formatter.format(1999), "1K+")
        XCTAssertEqual(formatter.format(2000), "2K")
        XCTAssertEqual(formatter.format(10000), "10K")
        XCTAssertEqual(formatter.format(999999), "999K+")
        XCTAssertEqual(formatter.format(1000000), "1M")
        XCTAssertEqual(formatter.format(2500000), "2M+")
        XCTAssertEqual(formatter.format(999999999), "999M+")
        XCTAssertEqual(formatter.format(1000000000), "1B")
        XCTAssertEqual(formatter.format(1500000000), "1B+")
    }
}

