//
//  LocalStorage.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

protocol LocalStorage {
    func saveUsers(_ users: [GitUser]) async
    func loadUsers() async -> [GitUser]
}
