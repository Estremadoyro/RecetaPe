//
//  RPeLogger.swift
//  RecetaPe
//
//  Created by Leonardo  on 9/01/23.
//

import Foundation

/// Available log types.
enum LogType {
    case info
    case request
    case error
}

/// Model for logging msgs. into console.
enum RPeLogger<T> {
    /// Logs a message with a set format.
    /// - Parameter msg: Raw log msg.
    /// - Parameter logType: The type of log to input.
    /// - Returns: Final parsed message.
    @discardableResult
    static func log(_ msg: String, _ logType: LogType = .info) -> String {
        var icon: String = ""

        switch logType {
            case .info: icon = "ℹ️"
            case .request: icon = "🌐"
            case .error: icon = "❌"
        }
        
        let finalLog: String = "senku | \(T.self) [\(icon)] | - \(msg)"
        print(finalLog)
        return finalLog
    }
}

typealias Logger = RPeLogger
