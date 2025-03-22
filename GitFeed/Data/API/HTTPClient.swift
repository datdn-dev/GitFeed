//
//  HTTPClient.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

/// A protocol defining an HTTP client responsible for making network requests.
protocol HTTPClient {
    /// Sends an HTTP request to a specified endpoint and decodes the response.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint to send the request to.
    ///   - decoder: The `JSONDecoder` used to decode the response data.
    /// - Returns: A decoded object of type `T`.
    /// - Throws: An error if the request fails or the decoding process encounters an issue.
    func request<T: Decodable>(endpoint: Endpoint, decoder: JSONDecoder) async throws -> T
}
