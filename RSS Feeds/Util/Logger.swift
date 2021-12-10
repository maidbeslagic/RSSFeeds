//
//  Logger.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 9. 12. 2021..
//

import Foundation

enum LogLevel {
    case none, debug, info, warning, error, fatal
}

enum LogType {
    case plain, debug, warning, error
}

final class Logger {
    private let dispatchQueue = DispatchQueue(label: "com.maidbeslagic.rssfeeds.logger", qos: .background)
    private var level: LogLevel
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
    
    init(level: LogLevel = .debug) {
        self.level = level
    }
    
    func log(_ message: String,
             type: LogType = .debug,
             file: String = #file,
             line: Int = #line,
             function: String = #function,
             date: Date = Date()) {
        dispatchQueue.sync {
            self.composeLog(type: type,
                            message: message,
                            file: file,
                            line: line,
                            function: function,
                            date: date)
        }
    }
    
    private func composeLog(type: LogType = .plain,
                            message: String,
                            file: String,
                            line: Int,
                            function: String,
                            date: Date) {
        var logMessage = String()
        switch type {
        case .debug:
            logMessage += "🟢"
        case .warning:
            logMessage += "🟡"
        case .error:
            logMessage += "🔴"
        default:
            break
        }
        
        logMessage += parseDate(date)
        logMessage += parseLogLocation(file: file,
                                       line: line,
                                       function: function)
        logMessage += message
        
        if level != .none {
            print(logMessage)
        }
    }
    
    private func parseLogLocation(file: String,
                                  line: Int,
                                  function: String) -> String {
        
        let fileName = stripFilePathAndExtension(file: file)
        return " \(fileName).\(function):\(line) "
             
    }
    
    private func stripFilePathAndExtension(file: String ) -> String {
        let fileName = file.components(separatedBy: "/").last ?? ""
        var components = fileName.components(separatedBy: ".")
        guard components.count > 1 else { return fileName }
        components.removeLast()
        return components.joined(separator: ".")
    }
    
    private func parseDate(_ date: Date) -> String {
        let stringDate = dateFormatter.string(from: date)
        return " [\(stringDate)]"
    }
}
