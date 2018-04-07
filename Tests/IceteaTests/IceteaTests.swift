import Foundation
import XCTest
@testable import IceteaCore

@available(macOS 10.12, *)
final class IceteaTests: XCTestCase {

    private let directory: String = {
        return "\(FileManager.default.temporaryDirectory)/IceteaTests"
    }()

    override func setUp() {
        super.setUp()
        try! FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
    }

    override func tearDown() {
        try! FileManager.default.removeItem(atPath: directory)
        super.tearDown()
    }

    func testFindFileInDirectory() throws {
        XCTAssertTrue(FileManager.default.createFile(atPath: "\(directory)/a", contents: nil, attributes: nil))
        XCTAssertTrue(FileManager.default.createFile(atPath: "\(directory)/b", contents: nil, attributes: nil))
        XCTAssertTrue(FileManager.default.createFile(atPath: "\(directory)/c.swift", contents: nil, attributes: nil))
        XCTAssertEqual(1, try FileSystem().findFiles(withExtensions: [".swift"], at: directory, recursive: false).count)
    }

    func testFindFilesIncludingSubdirectories() throws {
        try! FileManager.default.createDirectory(atPath: "\(directory)/a", withIntermediateDirectories: true, attributes: nil)
        try! FileManager.default.createDirectory(atPath: "\(directory)/b/1", withIntermediateDirectories: true, attributes: nil)
        try! FileManager.default.createDirectory(atPath: "\(directory)/c", withIntermediateDirectories: true, attributes: nil)

        XCTAssertTrue(FileManager.default.createFile(atPath: "\(directory)/test1.swift", contents: nil, attributes: nil))
        XCTAssertTrue(FileManager.default.createFile(atPath: "\(directory)/a/test2.swift", contents: nil, attributes: nil))
        XCTAssertTrue(FileManager.default.createFile(atPath: "\(directory)/b/test3.swift", contents: nil, attributes: nil))
        XCTAssertTrue(FileManager.default.createFile(atPath: "\(directory)/b/1test4.swift", contents: nil, attributes: nil))
        XCTAssertTrue(FileManager.default.createFile(atPath: "\(directory)/c/test5.swift", contents: nil, attributes: nil))

        XCTAssertTrue(FileManager.default.fileExists(atPath: "\(directory)/b/1test4.swift"))

        XCTAssertEqual(5, try FileSystem().findFiles(withExtensions: [".swift"], at: directory, recursive: true).count)
    }

}
