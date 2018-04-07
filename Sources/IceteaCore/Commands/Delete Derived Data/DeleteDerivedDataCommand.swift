//
//  DeleteDerivedDataCommand.swift
//  IceteaCore
//
//  Created by Sven Bacia on 07.04.18.
//

import Foundation
import Utility
import Basic

/// Deletes the Xcode derived data folder.
struct DeleteDerivedDataCommand: Command {

    // MARK: - Public Properties

    let command = "ddd"
    let overview = "🗑  Delete derived data."

    // MARK: - Private Properties

    private let parser: ArgumentParser
    private let closeArgument: OptionArgument<Bool>
    private let openArgument: OptionArgument<Bool>

    private var defaultPath: String = {
        guard #available(OSX 10.12, *) else { return "" }
        return "\(FileManager.default.homeDirectoryForCurrentUser.path)/Library/Developer/Xcode/DerivedData"
    }()

    // MARK: - Init

    init(parser: ArgumentParser) {
        self.parser = parser

        let subparser = parser.add(subparser: command, overview: overview)

        closeArgument = subparser.add(option: "--close",
                                      shortName: "-c",
                                      kind: Bool.self,
                                      usage: "💥  Xcode will be terminated before deleting the derived data folder.",
                                      completion: .none)

        openArgument = subparser.add(option: "--open",
                                     shortName: "-o",
                                     kind: Bool.self,
                                     usage: "🚀  Look for a Xcode workspace, project or playground in the current directory and opens it after the derived data folder got deleted.",
                                     completion: .none)
    }

    // MARK: - Actions

    func run(with arguments: ArgumentParser.Result) throws {
        // check if the close argument was specified
        if let close = arguments.get(closeArgument), close == true {
            try closeXcode()
        }

        // delete the derived data folder
        try deleteDerivedData(at: defaultPath)

        // check if the open xcode argument was specified
        if let open = arguments.get(openArgument), open == true {
            try openXcode()
        }
    }

    // MARK: - Helper

    private func closeXcode() throws {
        let process = Process(arguments: ["pkill", "Xcode"])
        try process.launch()
        try process.waitUntilExit()
        print("💥  Terminated Xcode.")
    }

    private func deleteDerivedData(at path: String) throws {
        let process = Process(arguments: ["rm", "-r", "-f", path])
        try process.launch()
        try process.waitUntilExit()
        print("🗑  Deleted derived data.")
    }

    private func openXcode() throws {
        // get all related files (workspace, project and playground) from the current directory
        let paths = try FileSystem().findFiles(withExtensions: XcodeFile.all.extensions, at: FileManager.default.currentDirectoryPath, recursive: false)
        if !paths.isEmpty {
            try Open.xcode(from: paths)
        } else {
            print("❌  No Xcode project found.")
        }
    }
}
