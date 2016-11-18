//
//  Run_Swift_Script.swift
//  Run Swift Script
//
//  Created by Felix Grabowski on 17/11/2016.
//  Copyright © 2016 FelixGrabowski. All rights reserved.
//

import Foundation
import Automator

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
        return ["\(hasTextView), \(changeVar)"]
    }
    
    /// avoiding cocoa bindings
    func textDidEndEditing(_ notification: Notification) {
        changeVar = "working"
        /// call update parameters here or some other stuff
    }
}
