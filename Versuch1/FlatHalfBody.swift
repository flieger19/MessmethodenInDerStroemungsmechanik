//
//  FlatHalfBody.swift
//  Versuch1
//
//  Created by Constantin Dullo on 06.06.16.
//  Copyright © 2016 Constantin Dullo. All rights reserved.
//

import Foundation

class FlatHalfBody: NSObject {
    
    //***************************************************************************************
    // variables
    //***************************************************************************************
    var pos         = [Double]()
    var phi         = [Double]()
    var p_stat      = [Double]()
    var cp          = [Double]()
    
    
    // boundary conditions
    var u_inf       = Double()
    var p_inf       = Double()
    var q_inf       = Double()
    var zero        = Double()
    
    //***************************************************************************************
    // classes
    //***************************************************************************************
    let inter       = Interpolation()
    let numbers     = IONumbers()
    let aero        = Aerodynamic()
    
    //***************************************************************************************
    // constants
    //***************************************************************************************
    let unitChange  = 9.809
    let density     = 1.18
    
    //***************************************************************************************
    // constructor
    //***************************************************************************************
    override init() {
        super.init()
        
        print("setup flat half body")
        self.readData()
    }
    
    //***************************************************************************************
    // methods
    //***************************************************************************************
    func readData() {
        // setup variables
        var pos1 = [Double]()
        var pos2 = [Double]()
        var phi1 = [Double]()
        var phi2 = [Double]()
        var p_stat1 = [Double]()
        var p_stat2 = [Double]()
        
        print("read data from meassurement protocol")
        pos1 = numbers.readeLines(1, start: 2, end: 9, row: 52)
        phi1 = numbers.readeLines(1, start: 2, end: 9, row: 53)
        p_stat1 = numbers.readeLines(1, start: 2, end: 9, row: 54)
        pos2 = numbers.readeLines(1, start: 2, end: 9, row: 55)
        phi2 = numbers.readeLines(1, start: 2, end: 9, row: 56)
        p_stat2 = numbers.readeLines(1, start: 2, end: 9, row: 57)
        
        for i in 0...pos1.count-1 {
            pos += [pos1[i]]
            phi += [phi1[i]]
            p_stat += [p_stat1[i]]
        }
        for i in 0...pos2.count-1 {
            pos += [pos2[i]]
            phi += [phi2[i]]
            p_stat += [p_stat2[i]]
        }
        
        // boundary conditions
        u_inf = numbers.readeLines(1, start: 2, end: 2, row: 6)[0]
        p_inf = numbers.readeLines(1, start: 2, end: 2, row: 7)[0]
        zero = numbers.readeLines(1, start: 2, end: 2, row: 51)[0]
    }
    
    func calcData() {
        print("calculate pressure Distribution for an flat half body")
    }
    
    func writeData() {
        print("write plot files")
    }
}