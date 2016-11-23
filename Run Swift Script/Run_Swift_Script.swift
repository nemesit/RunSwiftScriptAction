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

/// saves the input into userdefaults so that the script can use it too
/// input should be Array<String> else figure out the wanted type with dump(input)
/// if it is not Array<String> then it's retrieval method also needs to be changed e.g. from .stringArray(forKey... to .object(forKey...
func transferInput(_ input: Any?) throws {
    guard let input = input as? Array<String> else { return }
//    switch input {
//    case is Array<String>:
//        throw SwiftError.scriptError("Array<String>")
//    case is String:
//        throw SwiftError.scriptError("String")
//    case is NSURL:
//        throw SwiftError.scriptError("NSURL")
//    default:
//        throw SwiftError.scriptError("\(dump(input))")
//    }
    
    
    /// get input to where the script can find it
    UserDefaults(suiteName: "com.felixgrabowski.RunSwiftScript")?.setValue(input, forKey: "input")
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
        
        try transferInput(input)
        
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
//    }
}
