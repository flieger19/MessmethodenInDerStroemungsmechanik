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
    func readeLines(sheet: Int, start: Int, end: Int, row: Int) -> [Double] {
        // setup variables
        var myAppleScript = String()
        var result = [Double]()
        var error: NSDictionary?
        
        for i in start...end {
            // setup script
            myAppleScript = "set res to 0 \n tell application \"Numbers\" \n  \t  tell document 1 \n  \t   \t  tell sheet " + String(sheet) + " \n  \t   \t   \t  tell table 1 \n  \t   \t   \t   \t  set res to (value of cell " + String(i) + " of row " + String(row) + " )  \n  \t   \t   \t  end tell \n  \t   \t  end tell \n  \t  end tell \n end tell \n  \n return res \n "
            
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
    func readeColumns(sheet: Int, start: Int, end: Int, column: Int) -> [Double] {
        // setup variables
        var myAppleScript = String()
        var result = [Double]()
        var error: NSDictionary?
        
        for i in start...end {
            // setup script
            myAppleScript = "set res to 0 \n tell application \"Numbers\" \n  \t  tell document 1 \n  \t   \t  tell sheet " + String(sheet) + " \n  \t   \t   \t  tell table 1 \n  \t   \t   \t   \t  set res to (value of cell " + String(column) + " of row " + String(i) + " )  \n  \t   \t   \t  end tell \n  \t   \t  end tell \n  \t  end tell \n end tell \n  \n return res \n "
            
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
    func writeColumns(value: [Double], sheet: Int, start: Int, column: Int) {
        // setup variables
        var myAppleScript = String()
        var error: NSDictionary?
        
        for i in 0...(value.count-1) {
            // setup script
            myAppleScript = "set inf to 1000000000000 \n tell application \"Numbers\" \n  \t  tell document 1 \n  \t   \t  tell sheet " + String(sheet) + " \n  \t   \t   \t  tell table 1 \n  \t   \t   \t   \t  set (value of cell " + String(column) + " of row " + String(i+start) + " ) to " + String(value[i]) + "  \n  \t   \t   \t  end tell \n  \t   \t  end tell \n  \t  end tell \n end tell \n  \n return inf \n "
            
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
    func writeLines(value: [Double], sheet: Int, start: Int, row: Int) {
        // setup variables
        var myAppleScript = String()
        var error: NSDictionary?
        
        for i in 0...(value.count-1) {
            // setup script
            myAppleScript = "set inf to 1000000000000 \n tell application \"Numbers\" \n  \t  tell document 1 \n  \t   \t  tell sheet " + String(sheet) + " \n  \t   \t   \t  tell table 1 \n  \t   \t   \t   \t  set (value of cell " + String(i+start) + " of row " + String(row) + " ) to " + String(value[i]) + "  \n  \t   \t   \t  end tell \n  \t   \t  end tell \n  \t  end tell \n end tell \n  \n return inf \n "
            
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
    
    func writeHeader(variables: NSArray, option: NSString, numberOfValues: Int, sheet: Int, row: Int) {
        // setup variables
        var error: NSDictionary?
        
        // setup script
        var myAppleScript = "set res to 0 \n tell application \"Numbers\" \n  \t  tell document 1 \n  \t   \t  tell sheet " + String(sheet) + " \n  \t   \t   \t  tell table 1 \n  \t   \t   \t   \t  set (value of cell 1 of row " + String(row) + " ) to "
        if variables.objectAtIndex(0).isEqualToString("0") {
            myAppleScript = myAppleScript + "(\"ZONE I = " + String(numberOfValues) + " DATAPACKING=" + (option as String) + "\")  \n  \t   \t   \t  end tell \n  \t   \t  end tell \n  \t  end tell \n end tell \n  \n return res \n "
        } else {
            myAppleScript = myAppleScript + "(\"VARIABLES = \\\""
            for i in 0...variables.count-2 {
                myAppleScript = myAppleScript + (variables.objectAtIndex(i) as! String) + "\\\", \\\""
            }
            myAppleScript = myAppleScript + (variables.objectAtIndex(variables.count-1) as! String) + "\\\" \")  \n  \t   \t   \t   \t  set (value of cell 1 of row " + String(row+1) + " ) to (\"ZONE I = " + String(numberOfValues) + " DATAPACKING=" + (option as String) + "\")  \n  \t   \t   \t  end tell \n  \t   \t  end tell \n  \t  end tell \n end tell \n  \n return res \n "
        }
        
        // read header
        if let scriptObject = NSAppleScript(source: myAppleScript) {
            if let _: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
                &error) {
            } else if (error != nil) {
                print("error: \(error)")
            }
        }
    }
}