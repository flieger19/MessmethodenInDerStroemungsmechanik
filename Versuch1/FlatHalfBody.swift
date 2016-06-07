//
//  FlatHalfBody.swift
//  Versuch1
//
//  Created by Constantin Dullo on 06.06.16.
//  Copyright © 2016 Constantin Dullo. All rights reserved.
//

import Cocoa
import Foundation

class FlatHalfBody: NSObject {
    
    //***************************************************************************************
    // variables
    //***************************************************************************************
    var pos         = [Double]()
    var phi_m       = [Double]()
    var phi_i       = [Double]()
    var heigh       = [Double]()
    var p_stat      = [Double]()
    var cp_m        = [Double]()
    var cp_i        = [Double]()
    
    
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
    let alg         = Algorithm()
    
    
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
        self.calcData()
        self.writeData()
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
        var heigh1 = [Double]()
        var heigh2 = [Double]()
        
        print("read data from meassurement protocol")
        pos1 = numbers.readeLines(1, start: 2, end: 10, row: 52)
        phi1 = numbers.readeLines(1, start: 2, end: 10, row: 53)
        heigh1 = numbers.readeLines(1, start: 2, end: 10, row: 54)
        pos2 = numbers.readeLines(1, start: 2, end: 10, row: 55)
        phi2 = numbers.readeLines(1, start: 2, end: 10, row: 56)
        heigh2 = numbers.readeLines(1, start: 2, end: 10, row: 57)
        
        for i in 0...pos1.count-1 {
            pos += [pos1[i]]
            phi_m += [phi1[i]]
            heigh += [heigh1[i]]
        }
        for i in 0...pos2.count-1 {
            pos += [pos2[i]]
            phi_m += [phi2[i]]
            heigh += [heigh2[i]]
        }
        
        let sortedData: NSArray = alg.sortX(phi_m, y: heigh, z: pos)
        phi_m = sortedData.objectAtIndex(0) as! [Double]
        heigh = sortedData.objectAtIndex(1) as! [Double]
        pos = sortedData.objectAtIndex(2) as! [Double]
        
        // boundary conditions
        u_inf = numbers.readeLines(1, start: 2, end: 2, row: 6)[0]
        p_inf = numbers.readeLines(1, start: 2, end: 2, row: 7)[0]
        zero = numbers.readeLines(1, start: 2, end: 2, row: 51)[0]
    }
    
    func calcData() {
        print("calculate pressure Distribution for an flat half body")
        // boundary conditions
        q_inf = aero.dynamicPressure(density, u: u_inf)
        
        
        for i in 0...pos.count-1 {
            p_stat += [heigh[i]/zero*p_inf]
            cp_m += [aero.pressureDistribution(p_stat[i], p_inf: p_inf, q_inf: q_inf)]
        }
        
        phi_i = inter.creatX(phi_m[0], end: phi_m[phi_m.count-1], step: 1)
        
        for i in phi_i {
            cp_i += [inter.spline(phi_m, a: cp_m, inter: i)]
        }
    }
    
    func writeData() {
        print("write plot files")
        
        var vars: NSArray = ["Winkel [°]", "cp real", "cp theoretisch"]
        numbers.writeHeader(vars, option: "POINT", numberOfValues: phi_i.count, sheet: 8, row: 1)
        
        numbers.writeColumns(phi_i, sheet: 8, start: 3, column: 1)
        numbers.writeColumns(cp_i, sheet: 8, start: 3, column: 2)
        
        vars = ["0"]
        numbers.writeHeader(vars, option: "POINT", numberOfValues: phi_m.count, sheet: 8, row: phi_i.count+3)
        
        numbers.writeColumns(phi_m, sheet: 8, start: phi_i.count+4, column: 1)
        numbers.writeColumns(cp_m, sheet: 8, start: phi_i.count+4, column: 2)
    }
}