//
//  Kreiszylinder.swift
//  Versuch1
//
//  Created by Constantin Dullo on 03.06.16.
//  Copyright © 2016 Constantin Dullo. All rights reserved.
//

import Foundation

class CircularCylinder: NSObject {
    // "Constructor"
    override init() {
        //***************************************************************************************
        // setup Variables
        //***************************************************************************************
        
        print("setup circular cylinder")
        
        // measurement
        // contour
        var angle_m     = [Double]()
        var p_s_a_m     = [Double]()
        //x-Axsis
        var x_m         = [Double]()
        var p_s_x_m     = [Double]()
        var p_g_x_m     = [Double]()
        //y-Axsis
        var y_m         = [Double]()
        var p_s_y_m     = [Double]()
        var p_g_y_m     = [Double]()
        
        // Interpolat
        // contour
        var angle_i     = [Double]()
        var p_s_a_i     = [Double]()
        //x-Axsis
        var x_i         = [Double]()
        var p_s_x_i     = [Double]()
        var p_g_x_i     = [Double]()
        //y-Axsis
        var y_i         = [Double]()
        var p_s_y_i     = [Double]()
        var p_g_y_i     = [Double]()
        
        // boundary conditions
        var u_inf       =  Double()
        var p_inf       =  Double()
        var q_inf       =  Double()
        var d_inf       =  Double()
        
        // constants
        let unitChange  = 9.809
        let density     = 1.18
        
        // classes
        let numbers     = IONumbers()
        let aero        = Aerodynamic()
        
        
        //***************************************************************************************
        // read data from meassurement protocol
        //***************************************************************************************
        print("read data from meassurement protocol")
        // contour
        angle_m = numbers.readeLines(2, end: 15, row: 38)
        p_s_a_m = numbers.readeLines(2, end: 15, row: 39)
        
        // x-Axsis
        x_m = numbers.readeLines(2, end: 14, row: 41)
        p_s_x_m = numbers.readeLines(2, end: 14, row: 42)
        p_g_x_m = numbers.readeLines(2, end: 14, row: 43)
        
        // y-Axsis
        y_m = numbers.readeLines(2, end: 7, row: 45)
        p_s_y_m = numbers.readeLines(2, end: 7, row: 46)
        p_g_y_m = numbers.readeLines(2, end: 7, row: 47)
        
        // boundary conditions
        u_inf = numbers.readeLines(2, end: 2, row: 6)[0]
        u_inf = numbers.readeLines(2, end: 2, row: 7)[0]
        d_inf = numbers.readeLines(2, end: 2, row: 11)[0]
        
        
        //***************************************************************************************
        // calculate pressure Distribution for an circular cylinder
        //***************************************************************************************
        print("calculate pressure Distribution for an circular cylinder d = " + String(d_inf) + "m and speed u_inf = " + String(u_inf) + "m/s")
        
        
        //***************************************************************************************
        // write plot files
        //***************************************************************************************
        print("write plot files")
    }
    
    // calculate pressure Distribution on the contour
    func contour(phi: Double) -> Double {
        
        return 1 - 4*pow(sin(phi), 2)
    }
    
    // calculate pressure Distribution on the x-axis
    func xAxsis(x: Double, R: Double) -> Double {
        
        return pow(R/x, 2)*(2 - pow(R/x, 2))
    }
    
    // calculate pressure Distribution on the y-axsis
    func yAxis(y: Double, R: Double) -> Double {
        
        return -pow(R/y, 2)*(2 + pow(R/y, 2))
    }
    
    func interpolateData(x_m: [Double], y_m: [Double], x_i: [Double]) -> [Double] {
        
        // setup variables
        let inter = Interpolation()
        var polynom = [Double]()
    
        for i in x_i {
            polynom += [inter.lagrange(i, xi: x_m, yi: x_m)]
        }
        
        return polynom
    }
}