//
//  LogUtil.swift
//  LogGrabberUITests
//
//  Created by Amit Gupta on 10/22/19.
//  Copyright © 2019 Amit Gupta. All rights reserved.
//
import XCTest

// allLogs and seperator is required to be provided by the application
protocol LogVerification {
    //required to be provided by app's UITest target
    var allLogs: String? { get }
    //required to be provided by app's UITest target
    var separator: Character? { get }
    //log array to hold log statements from UITextView
    var logArray: [String]? { get }
    
    //Utility methods to get log statements from array.
    func contains(log: String) -> Bool
    func doesNotContain(log: String) -> Bool
    func matchesCompletely(log: String) -> Bool
    func matchesCompletelyWithMultipleOccurrence(log: String, frequency: Int) -> Bool
    func matchesCompletely(logsToVerify: [String]) -> Bool
}

extension LogVerification {
    
    var logArray: [String]? {
        guard let allLogs = self.allLogs else {
            XCTFail("failed to create logArray as no logs found")
            return nil
        }
        
        guard let seperator = self.separator else {
            XCTFail("failed to logArray as no separator found")
            return nil
        }
        
        let logArray = allLogs.split(separator: seperator)
        if logArray.isEmpty {
            XCTFail("failed to verify logs as they are present in wrong format, dumping all logs: \(allLogs)")
            return nil
        }
        
        var returnArray = [String]()
        logArray.forEach { (subString) in
            returnArray.append(String(subString))
        }
        return returnArray
    }
    
    /// searches logs in all of application logs
    /// It tries to match to the exact log or if the log is found as a substring of one of the logs
    /// - Parameter log: log to be validated
    /// - Returns: true if exact log is found or log is found as a substring of one of the logs
    func contains(log: String) -> Bool {
        guard let logArray = self.logArray, logArray.isEmpty == false else {
            XCTFail("failed to get logs: \(String(describing: self.logArray))")
            return false
        }
        return logArray.filter { $0 == log || $0.range(of: log) != nil }.isEmpty == false
    }
    
    /// It does inverse of `func contains(log: String) -> Bool`
    /// - Parameter log: log to be validated
    /// - Returns: false if exact log is found or log is found as a substring of one of the logs
    func doesNotContain(log: String) -> Bool {
        guard let logArray = self.logArray, logArray.isEmpty == false else {
            //we should fail since we are actually not performing any validation
            XCTFail("failed to get logs: \(String(describing: self.logArray))")
            return false
        }
        
        return self.contains(log: log) == false
    }
    
    /// searches logs in all of application logs
    /// It tries to match to the exact log
    /// - Parameter log: log to be validated
    /// - Returns: true if exact log is found else false
    func matchesCompletely(log: String) -> Bool {
        guard let logArray = self.logArray, logArray.isEmpty == false else {
            XCTFail("failed to get logs: \(String(describing: self.logArray))")
            return false
        }
        
        return logArray.filter { $0 == log }.isEmpty == false
    }
}

extension XCUIApplication {
    var separator: Character? {
        return "\n"
    }
    
    var allLogs: String? {
        let loggingTextViewAccessibilityIdentifier = "com.vmware.automationlogging.loggradder"
        guard self.textViews[loggingTextViewAccessibilityIdentifier].exists else {
            print("failed to verify logs as no logView present. This possibly can happen when using incorrect app instance")
            return nil
        }
        
        let view = self.textViews[loggingTextViewAccessibilityIdentifier]
        guard let allLogs = view.value as? String else {
            print("failed to verify logs as no logs found on logView")
            return nil
        }
        
        return allLogs
    }
}
