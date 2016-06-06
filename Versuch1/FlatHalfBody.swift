//
//  FlatHalfBody.swift
//  Versuch1
//
//  Created by Constantin Dullo on 06.06.16.
//  Copyright © 2016 Constantin Dullo. All rights reserved.
//

import Foundation

class FlatHalfBody: NSObject {
    
    // variables
    
    
    // constructor
    override init() {
        super.init()
        
        print("setup flat half body")
    }
    
    // methods
    func readData() {
        print("read data from meassurement protocol")
    }
    
    func calcData() {
        print("calculate pressure Distribution for an flat half body")
    }
    
    func writeData() {
        print("write plot files")
    }
}