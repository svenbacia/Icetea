//
//  Open.swift
//  IceteaCore
//
//  Created by Sven Bacia on 07.04.18.
//

import Foundation
import Basic

struct Open {

    /// Open Xcode file at the specified path.
    ///
    /// - Parameter path: Xcode file path.
    /// - Throws: When Xcode could not be opened.
    static func xcode(at path: String) throws {
        print("🚀  Open Xcode at \(path)")
        try Open.at(path)
    }

    /// Open Xcode file with the highest priority.
    /// Priority: workspace > project > playground.
    ///
    /// - Parameter paths: Xcode file paths.
    /// - Throws: When Xcode could not be opened.
    static func xcode(from paths: [String]) throws {
        // open xcode by priority: workspaces > projects > playgrounds
        for ext in XcodeFile.all.extensions {
            guard let path = paths.first(where: { $0.hasSuffix(ext) }) else { continue }
            try Open.xcode(at: path)
            return
        }
    }

    // MARK: - Helper

    private static func at(_ path: String) throws {
        let process = Process(arguments: ["open", path])
        try process.launch()
        try process.waitUntilExit()
    }
}
