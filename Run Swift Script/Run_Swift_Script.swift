//
//  Run_Swift_Script.swift
//  Run Swift Script
//
//  Created by Felix Grabowski on 17/11/2016.
//  Copyright © 2016 FelixGrabowski. All rights reserved.
//

import Foundation
import Automator

enum SwiftError: Error, CustomNSError {
    case noParameters
    case noScript
    case scriptError(String)
    
    static var errorDomain: String {
        return "ScriptError"
    }
    
    var errorCode: Int {
        switch self {
        case .noParameters:
            return 0
        case .noScript:
            return 1
        case .scriptError(_):
            return errOSAScriptError
        }
    }
    var errorUserInfo: [String : Any] {
        switch self {
        case .noParameters:
            return [:]
        case .noScript:
            return [:]
        case .scriptError(let message):
            /// the docs say OSAScriptErrorMessage should work - it doesn't
            /// therefore NSLocalizedDescriptionKey gets the job done
            return [OSAScriptErrorNumber : errOSAScriptError, OSAScriptErrorMessage : message, NSLocalizedDescriptionKey: message]
        }
    }
}




class Run_Swift_Script: AMBundleAction, NSTextViewDelegate {
    var changeVar = "not working"
    var hasTextView = false
    
    /// avoiding cocoa bindings
    @IBOutlet var textView: NSTextView? {
        didSet {
            hasTextView = true
            guard let t = textView else { return }
            t.delegate = self
        }
        
    }
    /// If the container type of the action’s AMProvides property is List, prepare an output array for later use (usually by creating an NSMutableArray object)
    /// Iterate through the elements of the input array and for each perform whatever operation is required and write the resulting data item to the output array
    override func run(withInput input: Any?) throws -> Any {
        guard let params = parameters else { throw SwiftError.noParameters }
        guard let script: String = params.object(forKey: "script" as NSString) as? String else { throw SwiftError.noScript }
        if script.isEmpty { return [] } // TODO: complete whitespace check
        let swiftOutput = try runSwift(script: script)
        return ["\(swiftOutput)"]
    }
    
    /// avoiding cocoa bindings
    func textDidEndEditing(_ notification: Notification) {
        changeVar = "working"
        /// call update parameters here or some other stuff
        updateParameters()
    }
    
    override func updateParameters() {
        guard let script = textView?.string else { return }
        guard let params = parameters else { return }
        params.setObject(script, forKey: "script" as NSString)
    }
//    override func parametersUpdated() {
//        guard let script: String = parameters?.object(forKey: "script" as NSString) as? String else { return }
//        guard let text = textView else { return }
//        text.string = script
//    }
}
