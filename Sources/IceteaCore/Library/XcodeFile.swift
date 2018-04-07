//
//  XcodeFile.swift
//  IceteaCore
//
//  Created by Sven Bacia on 07.04.18.
//

import Foundation

enum XcodeFile: String {
    case workspace
    case project
    case playground

    static var all: [XcodeFile] = [.workspace, .project, .playground]

    var ext: String {
        switch self {
        case .workspace:
            return ".xcworkspace"
        case .project:
            return ".xcodeproj"
        case .playground:
            return ".playground"
        }
    }
}

extension Array where Element == XcodeFile {
    var extensions: [String] {
        return map { $0.ext }
    }
}
