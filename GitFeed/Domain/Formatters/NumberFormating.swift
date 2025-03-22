//
//  NumberFormating.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import Foundation

protocol NumberFormating {
    /// Formats a given integer into a human-readable short format (e.g., 1K, 5M+).
    /// - Parameter number: The number to format.
    /// - Returns: A formatted string with appropriate suffix (K, M, B).
    func format(_ number: Int) -> String
}

struct SocialNumberFormater: NumberFormating {
    func format(_ number: Int) -> String {
        let units = ["", "K", "M", "B"]
        var value = number
        var unitIndex = 0

        while value >= 1000, unitIndex < units.count - 1 {
            value /= 1000
            unitIndex += 1
        }

        let remainder = number % Int(pow(10.0, Double(unitIndex * 3)))
        return "\(value)" + units[unitIndex] + "\(remainder > 0 ? "+" : "")"
    }
}
