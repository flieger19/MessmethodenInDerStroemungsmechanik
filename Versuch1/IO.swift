//
//  IO.swift
//  Versuch1
//
//  Created by Constantin Dullo on 03.06.16.
//  Copyright © 2016 Constantin Dullo. All rights reserved.
//

import Foundation

class IONumbers: NSObject {
    
    func input(start: Int, end: Int, location: Int) -> [Double] {
        
        var myAppleScript = String()
        var result = [Double]()
        var error: NSDictionary?
        
        for i in start...end {
            // setup script
            myAppleScript = "set res to 0 \n tell application \"Numbers\" \n  \t  tell document 1 \n  \t   \t  tell sheet 1 \n  \t   \t   \t  tell table 1 \n  \t   \t   \t   \t  set res to (value of cell " + String(i) + " of row " + String(location) + " )  \n  \t   \t   \t  end tell \n  \t   \t  end tell \n  \t  end tell \n end tell \n  \n return res \n "
            
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
}