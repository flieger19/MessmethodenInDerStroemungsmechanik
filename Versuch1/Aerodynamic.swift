//
//  Aerodynamic.swift
//  Versuch1
//
//  Created by Constantin Dullo on 03.06.16.
//  Copyright © 2016 Constantin Dullo. All rights reserved.
//

import Cocoa
import Foundation

class Aerodynamic: NSObject {
    
    // calculate generall pressure Distribution
    func pressureDistribution(p: Double, p_inf: Double, q_inf: Double) -> Double {
        
        return (p - p_inf)/q_inf
    }
    
    // calculate generall dynamic pressure
    func dynamicPressure(rho: Double, u: Double) -> Double {
        
        return rho/2*pow(u, 2)
    }
    
}