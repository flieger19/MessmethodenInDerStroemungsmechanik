//
//  Interpolation.swift
//  Versuch1
//
//  Created by Constantin Dullo on 03.06.16.
//  Copyright © 2016 Constantin Dullo. All rights reserved.
//

import Foundation
import Cocoa
import Accelerate

class Interpolation: NSObject {
    
    var counter = 0
    
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
    
    func creatX(start: Double, end: Double, step: Double) -> [Double] {
        // setup variables
        var x = [Double]()
        var i =  start
        
        // loop
        while i<=end {
            x += [i]
            i = i + step
        }

        return x
    }
    
    func spline(xi: [Double], a: [Double], inter: Double) -> Double {
        if xi.count != a.count {
            return 0.0
        }
        
        let n = xi.count-1
        
        var h = [Double]()
        for j in 0...n-1 {
            h += [xi[j+1] - xi[j]]
        }
        
        var A = Matrix(rows: n+1, columns: n+1)
        A[0,0] = 1
        A[n,n] = 1
        
        for i in 1...n-1 {
            A[i,i-1] = h[i-1];
            A[i,i] = 2*(h[i-1]+h[i]);
            A[i,i+1] = h[i];
        }
        
        var b = [Double]()
        var part1 = Double()
        var part2 = Double()
        
        b += [0]
        for i in 1...n-1 {
            part1 = (3/h[i])*(a[i+1]-a[i])
            part2 = (3/h[i-1])*(a[i]-a[i-1])
            b += [part1 - part2]
        }
        b += [0]
        
        var matrix = [Double]()
        for i in 0...n {
            for j in 0...n {
                matrix += [A[i,j]]
            }
        }
        
        let cj = solve(matrix, b)
        
        var bj = [Double]()
        for i in 0...n-1 {
            part1 = (1/h[i])*(a[i+1]-a[i])
            part2 = (1/3*h[i])*(2*cj[i]+cj[i+1])
            bj += [part1 - part2]
        }
        
        var dj = [Double]()
        for i in 0...n-1 {
            part1 = (1/(3*h[i]))
            part2 = (cj[i+1]-cj[i])
            dj += [part1*part2]
        }
        
        var f = [Double]()
        let x = inter
        var part3 = Double()
        for i in 0...n-1 {
            part1 = bj[i]*(x-xi[i])
            part2 = cj[i]*pow(x-xi[i],2)
            part3 = dj[i]*pow(x-xi[i],3)
            f += [a[i] + part1 + part2 + part3]
        }
        
        var jl = 1
        var ju = n;
        var jm = 0;
        while ju - jl > 1 {
            jm = (jl + ju)/2
            if inter < xi[jm] {
                ju = jm
            } else {
                jl = jm
            }
        }
        
        if counter <= 20 {
            jl = 0
        }
        counter += 1
        
        print(jl)
        return f[jl]
    }
    
    func solve( A:[Double], _ B:[Double] ) -> [Double] {
        var inMatrix:[Double]       = A
        var solution:[Double]       = B
        // Get the dimensions of the matrix. An NxN matrix has N^2
        // elements, so sqrt( N^2 ) will return N, the dimension
        var N:__CLPK_integer        = __CLPK_integer( sqrt( Double( A.count ) ) )
        // Number of columns on the RHS
        var NRHS:__CLPK_integer     = 1
        // Leading dimension of A and B
        var LDA:__CLPK_integer      = N
        var LDB:__CLPK_integer      = N
        // Initialize some arrays for the dgetrf_(), and dgetri_() functions
        var pivots:[__CLPK_integer] = [__CLPK_integer](count: Int(N), repeatedValue: 0)
        var error: __CLPK_integer   = 0
        // Perform LU factorization
        dgetrf_(&N, &N, &inMatrix, &N, &pivots, &error)
        // Calculate solution from LU factorization
        _ = "T".withCString {
            dgetrs_( UnsafeMutablePointer($0), &N, &NRHS, &inMatrix, &LDA, &pivots, &solution, &LDB, &error )
        }
        return solution
    }
    
    struct Matrix {
        let rows: Int, columns: Int
        var grid: [Double]
        init(rows: Int, columns: Int) {
            self.rows = rows
            self.columns = columns
            grid = Array(count: rows * columns, repeatedValue: 0.0)
        }
        func indexIsValidForRow(row: Int, column: Int) -> Bool {
            return row >= 0 && row < rows && column >= 0 && column < columns
        }
        subscript(row: Int, column: Int) -> Double {
            get {
                assert(indexIsValidForRow(row, column: column), "Index out of range")
                return grid[(row * columns) + column]
            }
            set {
                assert(indexIsValidForRow(row, column: column), "Index out of range")
                grid[(row * columns) + column] = newValue
            }
        }
    }
}