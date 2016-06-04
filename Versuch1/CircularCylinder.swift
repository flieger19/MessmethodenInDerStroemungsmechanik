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
        super.init()
        //***************************************************************************************
        // setup Variables
        //***************************************************************************************
        
        print("setup circular cylinder")
        
        // measurement
        // contour
        var angle_m     = [Double]()
        var p_s_a_m     = [Double]()
        var cp_a_m      = [Double]()
        //x-Axsis
        var x_m         = [Double]()
        var p_s_x_m     = [Double]()
        var cp_x_m      = [Double]()
        var p_g_x_m     = [Double]()
        var cg_x_m      = [Double]()
        //y-Axsis
        var y_m         = [Double]()
        var p_s_y_m     = [Double]()
        var cp_y_m      = [Double]()
        var p_g_y_m     = [Double]()
        var cg_y_m      = [Double]()
        
        // Interpolat
        // contour
        var angle_i     = [Double]()
        var p_s_a_i     = [Double]()
        var cp_a_i      = [Double]()
        //x-Axsis
        var x_i         = [Double]()
        var p_s_x_i     = [Double]()
        var cp_x_i      = [Double]()
        var p_g_x_i     = [Double]()
        var cg_x_i      = [Double]()
        //y-Axsis
        var y_i         = [Double]()
        var p_s_y_i     = [Double]()
        var cp_y_i      = [Double]()
        var p_g_y_i     = [Double]()
        var cg_y_i      = [Double]()
        
        // calculated
        // contour
        var cp_a_c      = [Double]()
        //x-Axsis
        var cp_x_c      = [Double]()
        //y-Axsis
        var cp_y_c      = [Double]()
        
        // boundary conditions
        var u_inf       =  Double()
        var p_inf       =  Double()
        var q_inf       =  Double()
        var d_inf       =  Double()
        
        // constants
        let unitChange  = 9.809
        let density     = 1.18
        
        // classes
        let inter = Interpolation()
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
        p_inf = numbers.readeLines(2, end: 2, row: 7)[0]
        d_inf = numbers.readeLines(2, end: 2, row: 11)[0]
        
        //***************************************************************************************
        // calculate pressure Distribution for an circular cylinder
        //***************************************************************************************
        print("calculate pressure Distribution for an circular cylinder d = " + String(d_inf) + "m and speed u_inf = " + String(u_inf) + "m/s")
        
        // interpolation/culculation
        // contour
        angle_i = inter.creatX(angle_m[0], end: angle_m[angle_m.count-1], step: 1)
        p_s_a_i = self.interpolateData(angle_m, y_m: p_s_a_m, x_i: angle_i)
        for i in 0...angle_i.count-1 {
            cp_a_i += [aero.pressureDistribution(p_s_a_i[i] + p_inf, p_inf: p_inf, q_inf: q_inf)]
            cp_a_c += [self.contour(angle_i[i])]
        }
        
        //x-Axsis
        x_i = inter.creatX(x_m[0], end: x_m[x_m.count-1], step: 1)
        p_s_x_i = self.interpolateData(x_m, y_m: p_s_x_m, x_i: x_i)
        p_g_x_i = self.interpolateData(x_m, y_m: p_g_x_m, x_i: x_i)
        for i in 0...x_i.count-1 {
            cp_x_i += [aero.pressureDistribution(p_s_x_i[i] + p_inf, p_inf: p_inf, q_inf: q_inf)]
            cp_x_c += [self.xAxsisP(x_i[i], R: d_inf/2)]
            cg_x_i += [aero.pressureDistribution(p_g_x_i[i], p_inf: p_inf, q_inf: q_inf)]
        }
        
        //y-Axsis
        y_i = inter.creatX(y_m[0], end: y_m[y_m.count-1], step: 1)
        p_s_y_i = self.interpolateData(y_m, y_m: p_s_y_m, x_i: y_i)
        p_g_y_i = self.interpolateData(y_m, y_m: p_g_y_m, x_i: y_i)
        for i in 0...y_i.count-1 {
            cp_y_i += [aero.pressureDistribution(p_s_y_i[i] + p_inf, p_inf: p_inf, q_inf: q_inf)]
            cp_y_c += [self.yAxsisP(y_i[i], R: d_inf/2)]
            cg_y_i += [aero.pressureDistribution(p_g_y_i[i], p_inf: p_inf, q_inf: q_inf)]
        }
            
        // boundary conditions
        q_inf = aero.dynamicPressure(density, u: u_inf)
        
        // measurement
        // contour
        for i in 0...angle_m.count-1 {
            cp_a_m += [aero.pressureDistribution(p_s_a_m[i] + p_inf, p_inf: p_inf, q_inf: q_inf)]
        }
        
        //x-Axsis
        for i in 0...x_m.count-1 {
            cp_x_m += [aero.pressureDistribution(p_s_x_m[i] + p_inf, p_inf: p_inf, q_inf: q_inf)]
            cg_x_m += [aero.pressureDistribution(p_g_x_m[i] + p_inf, p_inf: p_inf, q_inf: q_inf)]
        }
        
        //y-Axsis
        for i in 0...y_m.count-1 {
            cp_y_m += [aero.pressureDistribution(p_s_y_m[i] + p_inf, p_inf: p_inf, q_inf: q_inf)]
            cg_y_m += [aero.pressureDistribution(p_g_y_m[i] + p_inf, p_inf: p_inf, q_inf: q_inf)]
        }
        
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
    func xAxsisP(x: Double, R: Double) -> Double {
        
        return pow(R/x, 2)*(2 - pow(R/x, 2))
    }
    
    // calculate pressure Distribution on the y-axsis
    func yAxsisP(y: Double, R: Double) -> Double {
        
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