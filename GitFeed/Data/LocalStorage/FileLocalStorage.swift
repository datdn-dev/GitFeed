//
//  FileLocalStorage.swift
//  GitFeed
//
//  Created by Dat on 19/03/2025.
//

import Foundation

/// A class responsible for storing and retrieving users locally using a file system.
class FileLocalStorage: LocalStorage {
    /// The file URL where the user data will be stored.
    private let fileURL: URL?
    
    /// Initializes the local storage with a given file URL.
    ///
    /// - Parameter fileURL: The location of the file where user data will be saved.
    init(fileURL: URL?) {
        self.fileURL = fileURL
    }
    
    /// Saves an array of `GitUser` objects to a local file asynchronously.
    ///
    /// - Parameter users: The list of users to be saved.
    func saveUsers(_ users: [GitUser]) async {
        let encoder = JSONEncoder()
        guard let fileURL, let data = try? encoder.encode(users) else { return }
        try? data.write(to: fileURL)
    }
    
    /// Loads an array of `GitUser` objects from a local file asynchronously.
    ///
    /// - Returns: A list of users if the file exists and decoding is successful, otherwise returns an empty array.
    func loadUsers() async -> [GitUser] {
        let decoder = JSONDecoder()
        guard let fileURL, let data = try? Data(contentsOf: fileURL) else { return [] }
        guard let users = try? decoder.decode([GitUser].self, from: data) else { return [] }
        return users
    }
}
