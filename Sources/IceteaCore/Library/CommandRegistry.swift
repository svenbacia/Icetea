//
//  CommandRegistry.swift
//  IceteaCore
//
//  Created by Sven Bacia on 06.04.18.
//

import Foundation
import Utility
import Basic

struct CommandRegistry {

    private let parser: ArgumentParser
    private var commands: [Command]

    init(usage: String, overview: String) {
        self.parser = ArgumentParser(usage: usage, overview: overview)
        self.commands = []
    }

    func run() throws {
        let parsedArguments = try parse()
        try process(arguments: parsedArguments)
    }

    mutating func register(_ command: Command.Type) {
        commands.append(command.init(parser: parser))
    }

    private func parse() throws -> ArgumentParser.Result {
        let arguments = CommandLine.arguments.dropFirst()
        return try parser.parse(Array(arguments))
    }

    private func process(arguments: ArgumentParser.Result) throws {
        guard let subparser = arguments.subparser(parser), let command = commands.first(where: { $0.command == subparser }) else {
            parser.printUsage(on: stdoutStream)
            return
        }
        try command.run(with: arguments)
    }
}
