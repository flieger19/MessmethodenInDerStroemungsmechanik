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
        var cp_a_i      = [Double]()
        //x-Axsis
        var x_i         = [Double]()
        var cp_x_i      = [Double]()
        var cg_x_i      = [Double]()
        //y-Axsis
        var y_i         = [Double]()
        var cp_y_i      = [Double]()
        var cg_y_i      = [Double]()
        
        // calculated
        // contour
        var cp_a_c      = [Double]()
        //x-Axsis
        var cp_x_c      = [Double]()
        var cg_x_c      = [Double]()
        //y-Axsis
        var cp_y_c      = [Double]()
        var cg_y_c      = [Double]()
        
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
        angle_m = numbers.readeLines(1, start: 2, end: 15, row: 38)
        p_s_a_m = numbers.readeLines(1, start: 2, end: 15, row: 39)
        
        // x-Axsis
        x_m = numbers.readeLines(1, start: 2, end: 14, row: 41)
        p_s_x_m = numbers.readeLines(1, start: 2, end: 14, row: 42)
        p_g_x_m = numbers.readeLines(1, start: 2, end: 14, row: 43)
        
        // y-Axsis
        y_m = numbers.readeLines(1, start: 2, end: 7, row: 45)
        p_s_y_m = numbers.readeLines(1, start: 2, end: 7, row: 46)
        p_g_y_m = numbers.readeLines(1, start: 2, end: 7, row: 47)
        
        // boundary conditions
        u_inf = numbers.readeLines(1, start: 2, end: 2, row: 6)[0]
        p_inf = numbers.readeLines(1, start: 2, end: 2, row: 7)[0]
        d_inf = numbers.readeLines(1, start: 2, end: 2, row: 11)[0]
        
        
        //***************************************************************************************
        // calculate pressure Distribution for an circular cylinder
        //***************************************************************************************
        print("calculate pressure Distribution for an circular cylinder d = " + String(d_inf) + "m and speed u_inf = " + String(u_inf) + "m/s")
        
        // boundary conditions
        q_inf = aero.dynamicPressure(density, u: u_inf)
        
        // interpolation/culculation
        // contour
        angle_i = inter.creatX(angle_m[0], end: angle_m[angle_m.count-1], step: 1)
        for i in angle_i {
            //cp_a_i += [aero.pressureDistribution(inter.lagrange(i, xi: angle_m, yi: p_s_a_m) + p_inf, p_inf: p_inf, q_inf: q_inf)]
            cp_a_i += [aero.pressureDistribution(inter.spline(angle_m, a: p_s_a_m, inter: i) + p_inf, p_inf: p_inf, q_inf: q_inf)]
            cp_a_c += [self.contour(i)]
        }
        
        //x-Axsis
        x_i = inter.creatX(x_m[0], end: x_m[x_m.count-1], step: 1)
        for i in x_i {
            cp_x_i += [aero.pressureDistribution(inter.lagrange(i, xi: x_m, yi: p_s_x_m) + p_inf, p_inf: p_inf, q_inf: q_inf)]
            cp_x_c += [self.xAxsisP(i, R: d_inf/2)]
            cg_x_i += [aero.pressureDistribution(inter.lagrange(i, xi: x_m, yi: p_g_x_m), p_inf: p_inf, q_inf: q_inf)]
            cg_x_c += [1]
        }
        
        //y-Axsis
        y_i = inter.creatX(y_m[0], end: y_m[y_m.count-1], step: 1)
        for i in y_i {
            cp_y_i += [aero.pressureDistribution(inter.lagrange(i, xi: y_m, yi: p_s_y_m) + p_inf, p_inf: p_inf, q_inf: q_inf)]
            cp_y_c += [self.yAxsisP(i, R: d_inf/2)]
            cg_y_i += [aero.pressureDistribution(inter.lagrange(i, xi: y_m, yi: p_g_y_m), p_inf: p_inf, q_inf: q_inf)]
            cg_y_c += [1]
        }
        
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
        
        // contour
        var vars: NSArray = ["Winkel [°]", "cp real", "cp theoretisch"]
        numbers.writeHeader(vars, option: "POINT", numberOfValues: angle_i.count, sheet: 5, row: 1)
        
        numbers.writeColumns(angle_i, sheet: 5, start: 3, column: 1)
        numbers.writeColumns(cp_a_i, sheet: 5, start: 3, column: 2)
        numbers.writeColumns(cp_a_c, sheet: 5, start: 3, column: 3)
        
        vars = ["0"]
        numbers.writeHeader(vars, option: "POINT", numberOfValues: angle_m.count, sheet: 5, row: angle_i.count+3)
        
        numbers.writeColumns(angle_m, sheet: 5, start: angle_i.count+4, column: 1)
        numbers.writeColumns(cp_a_m, sheet: 5, start: angle_i.count+4, column: 2)
        
        //x-Axsis
        vars = ["x [mm]", "cp real", "cp theoretisch", "cg real", "cg theoretisch"]
        numbers.writeHeader(vars, option: "POINT", numberOfValues: x_i.count, sheet: 6, row: 1)
        
        numbers.writeColumns(x_i, sheet: 6, start: 3, column: 1)
        numbers.writeColumns(cp_x_i, sheet: 6, start: 3, column: 2)
        numbers.writeColumns(cp_x_c, sheet: 6, start: 3, column: 3)
        numbers.writeColumns(cg_x_i, sheet: 6, start: 3, column: 4)
        numbers.writeColumns(cg_x_c, sheet: 6, start: 3, column: 5)
        
        vars = ["0"]
        numbers.writeHeader(vars, option: "POINT", numberOfValues: x_m.count, sheet: 6, row: x_i.count+3)
        
        numbers.writeColumns(x_m, sheet: 6, start: x_i.count+4, column: 1)
        numbers.writeColumns(cp_x_m, sheet: 6, start: x_i.count+4, column: 2)
        numbers.writeColumns(cg_x_m, sheet: 6, start: x_i.count+4, column: 4)
        
        //y-Axsis
        vars = ["y [mm]", "cp real", "cp theoretisch", "cg real", "cg theoretisch"]
        numbers.writeHeader(vars, option: "POINT", numberOfValues: y_i.count, sheet: 7, row: 1)
        
        numbers.writeColumns(y_i, sheet: 7, start: 3, column: 1)
        numbers.writeColumns(cp_y_i, sheet: 7, start: 3, column: 2)
        numbers.writeColumns(cp_y_c, sheet: 7, start: 3, column: 3)
        numbers.writeColumns(cg_y_i, sheet: 7, start: 3, column: 4)
        numbers.writeColumns(cg_y_c, sheet: 7, start: 3, column: 5)
        
        vars = ["0"]
        numbers.writeHeader(vars, option: "POINT", numberOfValues: y_m.count, sheet: 7, row: y_i.count+3)
        
        numbers.writeColumns(y_m, sheet: 7, start: y_i.count+4, column: 1)
        numbers.writeColumns(cp_y_m, sheet: 7, start: y_i.count+4, column: 2)
        numbers.writeColumns(cg_y_m, sheet: 7, start: y_i.count+4, column: 4)
    }
    
    // calculate pressure Distribution on the contour
    func contour(phi: Double) -> Double {
        
        return 1 - 4*pow(sin(phi*M_PI/180), 2)
    }
    
    // calculate pressure Distribution on the x-axis
    func xAxsisP(x: Double, R: Double) -> Double {
        
        return pow(R/x, 2)*(2 - pow(R/x, 2))
    }
    
    // calculate pressure Distribution on the y-axsis
    func yAxsisP(y: Double, R: Double) -> Double {
        
        return -pow(R/y, 2)*(2 + pow(R/y, 2))
    }
}