//
//  Command.swift
//  IceteaCore
//
//  Created by Sven Bacia on 06.04.18.
//

import Foundation
import Utility

protocol Command {
    var command: String { get }
    var overview: String { get }

    init(parser: ArgumentParser)

    func run(with arguments: ArgumentParser.Result) throws
}
