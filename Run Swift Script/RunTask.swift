//
//  RunTask.swift
//  Run Swift Script
//
//  Created by Felix Grabowski on 17/11/2016.
//  Copyright © 2016 FelixGrabowski. All rights reserved.
//

import Foundation

func getOutput(_ p: Pipe) -> String {
    let outHandle = p.fileHandleForReading
    let data = outHandle.readDataToEndOfFile()
    outHandle.closeFile()

    guard let output = String(data: data, encoding: String.Encoding.utf8) else {
        return "getOutput FAIL"
    }
    return output
}

func run(swiftCode code: String) -> String {
    let p = Process()
    p.launchPath = "/usr/bin/swift"
    p.arguments = ["/dev/stdin"] // no welcome message and no repl mode

    /// Input/Output Pipes
    let stdin = Pipe()
    let stdout = Pipe()
    p.standardInput = stdin
    p.standardOutput = stdout

    /// write code to stdin
    let inHandle = stdin.fileHandleForWriting
    inHandle.write(code.data(using: String.Encoding.utf8)!)
    inHandle.closeFile()

    /// start process
    p.launch()
    p.waitUntilExit()

    /// retrieve output from stdout
    let output = getOutput(stdout)
    /// return output
    return output
}
//
//    override func run(withInput input: Any?) throws -> Any {
//        //        let output = run(swiftCode: "print(5)")
//        guard let params = self.parameters else { return "could not load parameters" }
//        guard let swiftCode = params.object(forKey: "swiftCode") else { return "key not found for swiftCode" }
//        guard let code: String = swiftCode as? String else { return "code not in string form" }
//        if code.isEmpty { return "no code \(params)" }
//        //        return "\(code)" + "print(\"whohoo\")"
//        let output = run(swiftCode: code)
//
//        return output
//        //        let output = run(swiftCode: "print(5)")
//        //        /// return output
//        //        return output
//    }
