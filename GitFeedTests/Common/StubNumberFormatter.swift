//
//  StubNumberFormatter.swift
//  GitFeedTests
//
//  Created by Dat on 21/03/2025.
//

import Foundation
@testable import GitFeed

class StubNumberFormatter: NumberFormating {
    func format(_ number: Int) -> String {
        if number >= 1000 {
            return "\(number / 1000)K"
        }
        return "\(number)"
    }
}
