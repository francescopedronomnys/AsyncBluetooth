// Copyright (c) 2024 Manuel Fernandez. All rights reserved.

import Foundation
import os.log

public final class AsyncBluetoothLogging: Sendable {

    private(set) static var isEnabled = true

    private static var loggerFactory: (String, String) -> CustomLogger = { subsystem, category in
        DefaultLogger(subsystem: subsystem, category: category)
    }

    public static func setEnabled(_ isEnabled: Bool) {
        Self.isEnabled = isEnabled
    }

    public static func setLoggerFactory(_ factory: @escaping (String, String) -> CustomLogger) {
        Self.loggerFactory = factory
    }

    public static func resetLoggerFactory() {
        Self.loggerFactory = { subsystem, category in
            DefaultLogger(subsystem: subsystem, category: category)
        }
    }

    static func createLogger(for category: String) -> CustomLogger {
        guard Self.isEnabled else { return DisabledLogger() }

        return loggerFactory(
            Bundle(for: CentralManager.self).bundleIdentifier ?? "",
            category
        )
    }
}

typealias Logging = AsyncBluetoothLogging

public protocol CustomLogger {

    func log(_ message: String)

    func log(level: OSLogType, _ message: String)

    func trace(_ message: String)

    func debug(_ message: String)

    func info(_ message: String)

    func notice(_ message: String)

    func warning(_ message: String)

    func error(_ message: String)

    func critical(_ message: String)

    func fault(_ message: String)
}

public struct DisabledLogger : CustomLogger {
    public init() {}
    public func log(_ message: String) {}
    public func log(level: OSLogType, _ message: String) {}
    public func trace(_ message: String) {}
    public func debug(_ message: String) {}
    public func info(_ message: String) {}
    public func notice(_ message: String) {}
    public func warning(_ message: String) {}
    public func error(_ message: String) {}
    public func critical(_ message: String) {}
    public func fault(_ message: String) {}
}

public struct DefaultLogger: CustomLogger {
    private let subsystem: String
    private let category: String
    private let logger: Logger

    public init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
        self.logger = Logger(subsystem: subsystem, category: category)
    }

    public func log(_ message: String) {
        logger.log("\(message)")
    }

    public func log(level: OSLogType, _ message: String) {
        logger.log(level: level, "\(message)")
    }

    public func trace(_ message: String) {
        logger.trace("\(message)")
    }

    public func debug(_ message: String) {
        logger.debug("\(message)")
    }

    public func info(_ message: String) {
        logger.info("\(message)")
    }

    public func notice(_ message: String) {
        logger.notice("\(message)")
    }

    public func warning(_ message: String) {
        logger.warning("\(message)")
    }

    public func error(_ message: String) {
        logger.error("\(message)")
    }

    public func critical(_ message: String) {
        logger.critical("\(message)")
    }

    public func fault(_ message: String) {
        logger.fault("\(message)")
    }
}
