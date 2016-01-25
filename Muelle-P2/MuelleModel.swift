//
//  MuelleModel.swift
//  Muelle-P2
//
//  Created by sanxlop on 7/10/15.
//  Copyright © 2015 UPM. All rights reserved.
//

import Foundation

class MuelleModel {
    
    //Masa del objeto
    var m = 20.0 {
        didSet {
            updateCtes()
        }
    }
    
    //Constante muelle
    var k = 1500.0 {
        didSet {
            updateCtes()
        }
    }
    
    //Constante de rozamiento
    var λ = 40.0 {
        didSet {
            updateCtes()
        }
    }
    
    init () {
        updateCtes()
    }
    
    //Posicion inicial de la masa
    private let x0 = 2.0
    
    //Velocidad inicial de la masa
    private let v0 = 0.0
    
    //Otras ctes
    private var w0 = 1.0
    private var y = 1.0
    private var w = 1.0
    private var A = 1.0
    private var φ = 1.0

    //Actualizacion de las ctes
    private func updateCtes() {
        w0 = sqrt(k / m)
        y = λ / m / 2
        w = sqrt(w0*w0 - y*y)
        A = sqrt(x0*x0 + pow((v0+y*x0)/w,2))
        φ = atan(x0*w/(v0+y*x0))
    }
    
    //Posicion de la masa respecto del tiempo
    func posAtTime(time: Double) -> Double {
        return A*exp(-y*time) * sin(w*time+φ)
    }
    
    //Velocidad de la masa respecto del tiempo
    func velAtTime(time: Double) -> Double {
        let part1 = A*exp(-y*time)
        let part2 = w*time+φ
        return -y*part1*sin(part2) + part1*w*cos(part2)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}