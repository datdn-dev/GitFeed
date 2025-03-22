//
//  FileLocalStorage.swift
//  GitFeed
//
//  Created by Dat on 19/03/2025.
//

import Foundation

class FileLocalStorage: LocalStorage {
    private let fileURL: URL?
    
    init(fileURL: URL?) {
        self.fileURL = fileURL
    }
    
    func saveUsers(_ users: [GitUser]) async {
        let encoder = JSONEncoder()
        guard let fileURL, let data = try? encoder.encode(users) else { return }
        try? data.write(to: fileURL)
    }
    
    func loadUsers() async -> [GitUser] {
        let decoder = JSONDecoder()
        guard let fileURL, let data = try? Data(contentsOf: fileURL) else { return [] }
        guard let users = try? decoder.decode([GitUser].self, from: data) else { return [] }
        return users
    }
}
