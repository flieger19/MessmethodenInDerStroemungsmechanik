//
//  IO.swift
//  Versuch1
//
//  Created by Constantin Dullo on 03.06.16.
//  Copyright © 2016 Constantin Dullo. All rights reserved.
//

import Foundation

class IONumbers: NSObject {
    // read file line by lines
    func readeLines(start: Int, end: Int, row: Int) -> [Double] {
        // setup variables
        var myAppleScript = String()
        var result = [Double]()
        var error: NSDictionary?
        
        for i in start...end {
            // setup script
            myAppleScript = "set res to 0 \n tell application \"Numbers\" \n  \t  tell document 1 \n  \t   \t  tell sheet 1 \n  \t   \t   \t  tell table 1 \n  \t   \t   \t   \t  set res to (value of cell " + String(i) + " of row " + String(row) + " )  \n  \t   \t   \t  end tell \n  \t   \t  end tell \n  \t  end tell \n end tell \n  \n return res \n "
            
            // read data from Table
            if let scriptObject = NSAppleScript(source: myAppleScript) {
                if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
                        &error) {
                    result += [output.doubleValue]
                } else if (error != nil) {
                    print("error: \(error)")
                }
            }
        }
        
        // return
        return result
    }
    
    // read file columns by columns
    func readeColumns(start: Int, end: Int, column: Int) -> [Double] {
        // setup variables
        var myAppleScript = String()
        var result = [Double]()
        var error: NSDictionary?
        
        for i in start...end {
            // setup script
            myAppleScript = "set res to 0 \n tell application \"Numbers\" \n  \t  tell document 1 \n  \t   \t  tell sheet 1 \n  \t   \t   \t  tell table 1 \n  \t   \t   \t   \t  set res to (value of cell " + String(column) + " of row " + String(i) + " )  \n  \t   \t   \t  end tell \n  \t   \t  end tell \n  \t  end tell \n end tell \n  \n return res \n "
            
            // read data from Table
            if let scriptObject = NSAppleScript(source: myAppleScript) {
                if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
                    &error) {
                    result += [output.doubleValue]
                } else if (error != nil) {
                    print("error: \(error)")
                }
            }
        }
        
        // return
        return result
    }
    
    // write file columns by columns
    func writeColumns(value: Double, start: Int, end: Int, row: Int) {
        // setup variables
        var myAppleScript = String()
        var error: NSDictionary?
        
        for i in start...end {
            // setup script
            myAppleScript = "set res to 0 \n tell application \"Numbers\" \n  \t  tell document 1 \n  \t   \t  tell sheet 1 \n  \t   \t   \t  tell table 1 \n  \t   \t   \t   \t  set (value of cell " + String(i) + " of row " + String(row) + " ) to " + String(value) + "  \n  \t   \t   \t  end tell \n  \t   \t  end tell \n  \t  end tell \n end tell \n  \n return res \n "
            
            // read data from Table
            if let scriptObject = NSAppleScript(source: myAppleScript) {
                if let _: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
                    &error) {
                    continue
                } else if (error != nil) {
                    print("error: \(error)")
                }
            }
        }
    }
    
    // write file line by lines
    func writeLines(value: Double, start: Int, end: Int, column: Int) {
        // setup variables
        var myAppleScript = String()
        var error: NSDictionary?
        
        for i in start...end {
            // setup script
            myAppleScript = "set res to 0 \n tell application \"Numbers\" \n  \t  tell document 1 \n  \t   \t  tell sheet 1 \n  \t   \t   \t  tell table 1 \n  \t   \t   \t   \t  set (value of cell " + String(column) + " of row " + String(i) + " ) to " + String(value) + "  \n  \t   \t   \t  end tell \n  \t   \t  end tell \n  \t  end tell \n end tell \n  \n return res \n "
            
            // read data from Table
            if let scriptObject = NSAppleScript(source: myAppleScript) {
                if let _: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
                    &error) {
                    continue
                } else if (error != nil) {
                    print("error: \(error)")
                }
            }
        }
    }
    
    func writeHeader(variables: NSArray, option: NSString, numberOfValues: Int, start: Int) {
        <#function body#>
    }
}