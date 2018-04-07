//
//  OpenXcodeCommand.swift
//  IceteaCore
//
//  Created by Sven Bacia on 06.04.18.
//

import Foundation
import Utility
import Basic

struct OpenXcodeCommand: Command {

    // MARK: - Public Properties

    let command = "open"
    let overview = "🚀  Find and open an Xcode workspace, project or playground."

    // MARK: - Private Properties

    private let parser: ArgumentParser
    private let listOption: OptionArgument<Bool>
    private let extensionOption: OptionArgument<String>
    private let pathOption: OptionArgument<String>

    // MARK: - Init

    init(parser: ArgumentParser) {
        self.parser = parser

        let subparser = parser.add(subparser: command, overview: overview)

        listOption = subparser.add(option: "--list",
                                   shortName: "-l",
                                   kind: Bool.self,
                                   usage: "📖  List all Xcode project files from the current directory (including subdirectories).",
                                   completion: .none)

        extensionOption = subparser.add(option: "--extension",
                                        shortName: "-e",
                                        kind: String.self,
                                        usage: "📦  Search for a specific Xcode file like workspace, project or playground",
                                        completion: .values([
                                            ("workspace", "Xcode Workspace"),
                                            ("project", "Xcode Project"),
                                            ("playground", "Xcode Playground"),
                                            ]))

        pathOption = subparser.add(option: "--path",
                                   shortName: "-p",
                                   kind: String.self,
                                   usage: "📁  Search in a specific subdirectory for the Xcode file.",
                                   completion: .filename)
    }

    // MARK: - Actions

    func run(with arguments: ArgumentParser.Result) throws {
        let isRecursive = arguments.get(listOption) ?? false
        let extensions = try self.extensions(from: arguments)
        let sourcePath = try self.path(from: arguments)
        let paths = try FileSystem().findFiles(withExtensions: extensions.extensions, at: sourcePath, recursive: isRecursive)

        guard !paths.isEmpty else {
            print("❌  No Xcode file found at \(path)")
            return
        }

        if isRecursive { // show list of results
            for (index, path) in paths.enumerated() {
                print("\(index + 1): \(path.dropFirst(sourcePath.count + 1))")
            }
            let number = readProjectNumber(count: paths.count)
            let path = paths[number]
            try Open.xcode(at: path)
        } else if let path = paths.first {
            try Open.xcode(at: path)
        }
    }

    // MARK: - Helper

    private func path(from arguments: ArgumentParser.Result) throws -> String {
        guard let subPath = arguments.get(pathOption) else { return FileManager.default.currentDirectoryPath }
        return FileManager.default.currentDirectoryPath.appending("/\(subPath)")
    }

    private func extensions(from arguments: ArgumentParser.Result) throws -> [XcodeFile] {
        guard let ext = arguments.get(extensionOption) else { return XcodeFile.all }
        guard let file = XcodeFile(rawValue: ext) else {
            throw ArgumentParserError.invalidValue(argument: "--extension", error: .unknown(value: ext))
        }
        return [file]
    }

    private func readProjectNumber(count: Int) -> Int {
        print("Choose your project:")
        while true {
            guard let input = readLine(), let number = try? Int(argument: input), number > 0, number <= count else {
                print("Invalid Input. Expects a number between 1 and \(count).")
                continue
            }
            return number
        }
    }
}
