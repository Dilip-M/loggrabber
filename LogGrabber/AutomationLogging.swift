//
//  AutomationLogging.swift
//  LogGrabber
//
//  Created by Amit Gupta on 10/22/19.
//  Copyright © 2019 Amit Gupta. All rights reserved.
//

import Foundation
import UIKit

public var XCUIAutomationLogger: XCUITestsLogValidationProtocol? = nil

public protocol AutomationLoggingView: class {
    //informs the XCUITests how logs are seperated from each other
    var seperator: String { get }
    //accessibilityIdentifier for the logging view
    var accessibilityIdentifier: String { get }
    //get the logvalidationview, this should be created in viewControllers.
    var loggingView: LogValidationView { get }
    //add a logging view to parentView
    func addLoggingView(parentView: UIView)
    //append log to UITextView
    func appendToLoggingView(message: String)
    //clear the log from UITextView
    func clearLogs()
}

public extension AutomationLoggingView {
    /// This should be added where it is sure that UI of the app has been initialized
    /// parentView should always be present in the view heirarchy for log validations to work
    func addLoggingView(parentView: UIView) {
        parentView.tag = LogValidationView.parentViewTag
        self.loggingView.accessibilityIdentifier = "com.vmware.automationlogging.loggradder"
        self.loggingView.text = "logging view first log."
        parentView.addSubview(self.loggingView)
    }
    
    func appendToLoggingView(message: String) {
        let previousLogs = self.loggingView.text ?? ""
        self.loggingView.text = previousLogs + message
    }
    
    func clearLogs() {
        self.loggingView.text = ""
    }
}

public protocol XCUITestsLogValidationProtocol: AutomationLoggingView {}

public extension XCUITestsLogValidationProtocol {
    
    //log single statement
    func log(_ msg: String) {
        self.logAutomationMessage(message: msg)
    }
    
    //variadic arg log
    func log(_ format: String, _ args: Any...) {
        let arguments = args as? [CVarArg]
        guard let cVarArgs = arguments else {
            print("automation logs is not in correct format")
            return
        }
        let msg = String(format: format, arguments: cVarArgs)
        self.logAutomationMessage(message: msg)
    }
    //log to UITextView
    func logAutomationMessage(message: String) {
        DispatchQueue.main.async {
            self.appendToLoggingView(message: message + self.seperator)
        }
    }
}

public class LogValidationView: UITextView {
    public static let parentViewTag = 333
}


