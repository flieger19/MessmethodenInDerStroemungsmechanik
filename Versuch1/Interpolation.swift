//
//  Interpolation.swift
//  Versuch1
//
//  Created by Constantin Dullo on 03.06.16.
//  Copyright © 2016 Constantin Dullo. All rights reserved.
//

import Foundation

class Interpolation: NSObject {
    
    func lagrange(x: Double, xi: [Double], yi: [Double]) -> Double {
        // setup variables
        var total = 1.0
        var lagrange = Double()
        
        // calculate interpolation point
        for i in 0...xi.count-1 {
            for j in 0...xi.count-1 {
                if i != j {
                    total *= (x - xi[j])/(xi[i] - xi[j])
                }
            }
            lagrange += yi[i]*total
            total = 1.0
        }
        
        // return
        return lagrange
    }
}