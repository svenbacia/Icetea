//
//  CreatePlaygroundCommand.swift
//  IceteaCore
//
//  Created by Sven Bacia on 08.04.18.
//

import Foundation
import Utility
import Basic
import Xgen

struct CreatePlaygroundCommand: Command {

    // MARK: - Public Properties

    let command = "playground"
    let overview = "🛠  Create and open a new Xcode playground."

    // MARK: - Private Properties

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter
    }()

    private let parser: ArgumentParser
    private let pathArgument: OptionArgument<String>
    private let targetArgument: OptionArgument<String>

    private var defaultPath: String = {
        guard #available(macOS 10.12, *) else { return "" }
        return "\(FileManager.default.homeDirectoryForCurrentUser.path)/Desktop/"
    }()

    private var defaultCode: String = {
        return "import Foundation\n\n"
    }()

    private var defaultFileName: String {
        return "\(type(of: self).dateFormatter.string(from: Date())).playground"
    }

    // MARK: - Init

    init(parser: ArgumentParser) {
        self.parser = parser

        let subparser = parser.add(subparser: command, overview: overview)

        pathArgument = subparser.add(option: "--path",
                                     shortName: "-p",
                                     kind: String.self,
                                     usage: "📁  Specify the path where the playground will be create. Default: ~/Desktop/",
                                     completion: .filename)

        targetArgument = subparser.add(option: "--target",
                                       shortName: "-t",
                                       kind: String.self,
                                       usage: "📱  Specify the playground platform target (ios, macos, tvos). Default: ios",
                                       completion: .values([("ios", "iOS Playground"), ("macos", "macOS Playground"), ("tvOS", "tvOS Playground")]))
    }

    // MARK: - Actions

    func run(with arguments: ArgumentParser.Result) throws {
        let path = self.path(from: arguments)
        let target = try self.target(from: arguments)
        let playground = Playground(path: path, platform: target, code: defaultCode)
        try playground.generate()
        try Open.xcode(at: path)
    }

    // MARK: - Helper

    private func path(from arguments: ArgumentParser.Result) -> String {
        guard let path = arguments.get(pathArgument) else { return defaultPath + defaultFileName }
        if path.hasSuffix(".playground") {
            return path
        } else if path.hasSuffix("/") {
            return path + defaultFileName
        } else {
            return "\(path)/\(defaultFileName)"
        }
    }

    private func target(from arguments: ArgumentParser.Result) throws -> Playground.Platform {
        guard let argument = arguments.get(targetArgument) else { return .iOS }
        guard let platform = Playground.Platform(rawValue: argument) else {
            throw ArgumentParserError.invalidValue(argument: "--target", error: .unknown(value: argument))
        }
        return platform
    }
}
