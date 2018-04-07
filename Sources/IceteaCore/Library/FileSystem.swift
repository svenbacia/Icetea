//
//  FileSystem.swift
//  IceteaCore
//
//  Created by Sven Bacia on 07.04.18.
//

import Foundation

struct FileSystem {

    // MARK: - Types

    private struct Result {
        let files: [String]
        let directories: [String]
    }

    // MARK: - Public Interface

    /// Finds all files with the specified file extensions at the given path. Subdirectories may be included.
    ///
    /// - Parameters:
    ///   - extensions: The file extensions.
    ///   - path: The path where the search should start.
    ///   - recursive: Indicates if subdirectories are included.
    /// - Returns: Returns all files with the specified file extensions at the given path.
    /// - Throws: When the contents of a directory could not be read.
    func findFiles(withExtensions extensions: [String], at path: String, recursive: Bool) throws -> [String] {
        if recursive {
            var result = [String]()
            try findFiles(withExtensions: extensions, at: [path], files: &result)
            return result
        } else {
            return try findFiles(withExtensions: extensions, at: path)?.files ?? []
        }
    }

    // MARK: - Private Helper

    private func findFiles(withExtensions extensions: [String], at paths: [String], files: inout [String]) throws {
        // we can return when there are no further directories
        guard !paths.isEmpty else { return }

        var subDirectories = [String]()

        // iterate over directories and search for an xcode file in each directory
        for path in paths {
            guard let result = try findFiles(withExtensions: extensions, at: path) else { continue }
            files.append(contentsOf: result.files)
            subDirectories.append(contentsOf: result.directories)
        }

        try findFiles(withExtensions: extensions, at: subDirectories, files: &files)
    }

    private func findFiles(withExtensions extensions: [String], at path: String) throws -> Result? {
        var files = [String]()
        var directories = [String]()

        // get contents of current directory
        let contents = try FileManager.default.contentsOfDirectory(atPath: path)

        // return nil when directory has no contents (has no xcode project)
        guard !contents.isEmpty else { return nil }

        // iterate over each file in the current directory
        for content in contents {

            let path = "\(path)/\(content)"

            // when we found an xcode file, we can return
            if extensions.contains(where: content.hasSuffix) {
                files.append(path)
                continue
            }

            // check if the current file is a directory
            var isDir = ObjCBool(booleanLiteral: false)
            if FileManager.default.fileExists(atPath: path, isDirectory: &isDir), isDir.boolValue {
                directories.append(path)
            }
        }

        return Result(files: files, directories: directories)
    }
}
