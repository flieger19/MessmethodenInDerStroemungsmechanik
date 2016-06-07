//
//  Algorithm.swift
//  Versuch1
//
//  Created by Constantin Dullo on 07.06.16.
//  Copyright © 2016 Constantin Dullo. All rights reserved.
//

import Cocoa
import Foundation

class Algorithm: NSObject {
    
    // variables
    var xValues = [Double]()
    var yValues = [Double]()
    var zValues = [Double]()
    
    // Constructor
    init(x: [Double], y: [Double], z: [Double]) {
        super.init()
        
        xValues = x
        yValues = y
        zValues = z
        
        self.isort()
    }
    
    // Methods
    func exchange(i: Int, j: Int) {
        
        var tmp = xValues[i]
        xValues[i] = xValues[j]
        xValues[j] = tmp
        
        tmp = yValues[i]
        yValues[i] = yValues[j]
        yValues[j] = tmp
        
        tmp = zValues[i]
        zValues[i] = zValues[j]
        zValues[j] = tmp
    }
    
    func swapLeft(index: Int) {
        
        for i in (1...index).reverse() {
            if xValues[i] < xValues[i-1] {
                exchange(i, j: i-1)
            } else {
                break
            }
        }
    }
    
    func isort() {
        
        for i in 1...xValues.count-1 {
            swapLeft(i)
        }
    }
    
    // setter and getter
    func sortX(x: [Double], y: [Double], z: [Double]) -> NSArray {
        
        xValues = x
        yValues = y
        zValues = z
        
        self.isort()
        
        return NSArray(objects: xValues, yValues, zValues)
    }
    
    func sorted() -> NSArray {
        
        return NSArray(objects: xValues, yValues, zValues)
    }
}
