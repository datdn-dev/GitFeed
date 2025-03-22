//
//  XCTestCase+Extension.swift
//  GitFeedTests
//
//  Created by Dat on 21/03/2025.
//

import Foundation
import XCTest

extension XCTestCase {
    func XCTAssertThrowsErrorAsync<T>(_ expression: @autoclosure () async throws -> T) async {
        do {
            _ = try await expression()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
