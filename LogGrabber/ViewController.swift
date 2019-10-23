//
//  ViewController.swift
//  LogGrabber
//
//  Created by Amit Gupta on 10/22/19.
//  Copyright © 2019 Amit Gupta. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, UIPageViewControllerDelegate {
    //create a logging view small enough, not visible.
    var loggingView: LogValidationView = LogValidationView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
   
    @IBOutlet weak var viewLog: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        XCUIAutomationLogger = self
        self.addLoggingView(parentView: self.view)
    }

    @IBAction func hitLogView(_ sender: Any) {
        print("Create logs in UIView")
        XCUIAutomationLogger?.log("InitialCheckDoneError:")
    }
}

//adopt XCUITestLogValidationProtocol
extension ViewController: XCUITestsLogValidationProtocol {
    var seperator: String {
        return "\n"
    }
    var accessibilityIdentifier: String {
        return "com.vmware.automationlogging.loggradder"
    }
}

