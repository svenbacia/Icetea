import Foundation
import Basic
import Utility

public final class Icetea {

    private var registry: CommandRegistry

    public init() {
        registry = CommandRegistry(usage: "[command] <options>", overview: "🍹  Icetea - Refreshment for Xcode users.")
        registry.register(OpenXcodeCommand.self)
        registry.register(DeleteDerivedDataCommand.self)
        registry.register(CreatePlaygroundCommand.self)
    }

    public func run() throws {
        try registry.run()
    }
}
