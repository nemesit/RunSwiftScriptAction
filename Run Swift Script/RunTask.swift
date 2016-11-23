//
//  RunTask.swift
//  Run Swift Script
//
//  Created by Felix Grabowski on 17/11/2016.
//  Copyright © 2016 FelixGrabowski. All rights reserved.
//

import Foundation

internal func getOutput(_ p: Pipe) -> String {
    let outHandle = p.fileHandleForReading
    let data = outHandle.readDataToEndOfFile()
    outHandle.closeFile()

    guard let output = String(data: data, encoding: String.Encoding.utf8) else {
        return "getOutput FAIL"
    }
    return output
}

/// split strings into buffer sized chunks
extension String {
    func components(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.characters.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return self[start..<end]
        }
    }
}

internal func runSwift(script code: String) throws -> String {
    var code = code
    let transferCode = "import Foundation;let input = UserDefaults(suiteName: \"com.felixgrabowski.RunSwiftScript\")?.stringArray(forKey: \"input\");"
    code = transferCode + code
    let p = Process()
    p.launchPath = "/usr/bin/swift"
    p.arguments = ["/dev/stdin"] // no welcome message and no repl mode

    /// Input/Output Pipes
    let stdin = Pipe()
    let stdout = Pipe()
    let stderr = Pipe()
    p.standardInput = stdin
    p.standardOutput = stdout
    p.standardError = stderr
    
    
    /// standard input
    let inHandle = stdin.fileHandleForWriting
    inHandle.writeabilityHandler = { pipeHandle in
        let splitString = code.components(withLength: 4000)
        for str in splitString {
            pipeHandle.write(str.data(using: String.Encoding.utf8)!)
        }
        inHandle.writeabilityHandler = nil
        inHandle.closeFile()
    }
    
    
    /// output
    var output = ""
    let outHandle = stdout.fileHandleForReading
    outHandle.readabilityHandler = { pipeHandle in
        if let line = String(data: pipeHandle.availableData, encoding: String.Encoding.utf8) {
            output += line
        } else {
            outHandle.readabilityHandler = nil
            outHandle.closeFile()
        }
        
    }
    /// error
    var error = ""
    let errHandle = stderr.fileHandleForReading
    errHandle.readabilityHandler = { pipeHandle in
        if let line = String(data: pipeHandle.availableData, encoding: String.Encoding.utf8) {
            error += line
        } else {
            errHandle.readabilityHandler = nil
            errHandle.closeFile()
        }
    }
    
    /// start process
    p.launch()
    p.waitUntilExit()

    
    if !error.isEmpty {
        throw(SwiftError.scriptError(error))
    }
    return output
}
