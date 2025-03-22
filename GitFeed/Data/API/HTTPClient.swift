//
//  HTTPClient.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

protocol HTTPClient {
    func request<T: Decodable>(endpoint: Endpoint, decoder: JSONDecoder) async throws -> T
}
