//
//  MuelleView.swift
//  Muelle-P2
//
//  Created by sanxlop on 7/10/15.
//  Copyright © 2015 UPM. All rights reserved.
//

import UIKit

struct Point {
    var x = 0.0
    var y = 0.0
}

protocol MuelleViewDataSource: class {
    
    func startTimeOfMuelleView(muelleView: MuelleView) -> Double
    func endTimeOfMuelleView(muelleView: MuelleView) -> Double
    func textOfMuelleView(muelleView: MuelleView) -> String
    func positionOfMuelleView(muelleView: MuelleView, atTime time: Double) -> Point
    
}

@IBDesignable
class MuelleView: UIView {
    
    @IBInspectable
    var lineWidth : Double = 2.0
    var lineWidthEjes : Double = 0.5
    
    @IBInspectable
    var graficaColor : UIColor = UIColor.redColor()
    var ejesColor : UIColor = UIColor.blackColor()
    
    //Numero de puntos en el eje X por unidad representada
    var scaleX: Double = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    //Numero de puntos en el eje Y por unidad representada
    var scaleY: Double = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    //Resolucion por numero de muestras tomadas
    var resolution: Double = 500 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    #if TARGET_INTERFACE_BUILDER
    var dataSource: MuelleViewDataSource!
    #else
    weak var dataSource: MuelleViewDataSource!
    #endif
    
    override func prepareForInterfaceBuilder() {
        
        class FakeDataSource : MuelleViewDataSource {
            
            func startTimeOfMuelleView(muelleView: MuelleView) -> Double  {return 0.0}
            
            func endTimeOfMuelleView(muelleView: MuelleView) -> Double {return 200.0}
            
            func textOfMuelleView(muelleView: MuelleView) -> String {return "Grafica"}
            
            func positionOfMuelleView(muelleView: MuelleView, atTime time: Double) -> Point {
                return Point(x: time, y: time%50)
            }
        }
        
        dataSource = FakeDataSource()
    }
    
    
    override func drawRect(rect: CGRect) {
        drawGrafica()
        drawEjes()
        drawText()
    }
    
    //Funcion que dibuja texto
    private func drawText() {
        let text = dataSource.textOfMuelleView(self)
        let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(7)]
        let pos = CGPointMake(5, 5)
        text.drawAtPoint(pos, withAttributes: attrs)
    }
    
    //Funcion que dibuja los ejes
    private func drawEjes() {
        
        let path = UIBezierPath()
        
        let width = bounds.size.width
        let height = bounds.size.height
        
        path.moveToPoint(CGPointMake(width/2, 0))
        path.addLineToPoint(CGPointMake(width/2, height))
        path.moveToPoint(CGPointMake(0, height/2))
        path.addLineToPoint(CGPointMake(width, height/2))
        
        path.lineWidth = CGFloat(lineWidthEjes)
        
        ejesColor.set()
        
        path.stroke()
    }
    
    //Funcion que dibuja las graficas
    private func drawGrafica() {
        
        let startTime = dataSource.startTimeOfMuelleView(self)
        let endTime = dataSource.endTimeOfMuelleView(self)
        let incrTime = max((endTime - startTime) / resolution , 0.01)
        
        let path = UIBezierPath()
        
        var point = dataSource.positionOfMuelleView(self, atTime: startTime)
        
        var px = pointForX(point.x)
        var py = pointForY(point.y)
        path.moveToPoint(CGPointMake(px, py))
        
        for var t:Double = startTime ; t < endTime ; t += incrTime {
            point = dataSource.positionOfMuelleView(self, atTime: t)
            px = pointForX(point.x)
            py = pointForY(point.y)
            path.addLineToPoint(CGPointMake(px, py))
        }
        
        path.lineWidth = CGFloat(lineWidth)
        
        graficaColor.set()
        
        path.stroke()
    }
    
    private func pointForX(x: Double) -> CGFloat {
        let width = bounds.size.width
        return width/2 + CGFloat(x*scaleX)
    }
    
    private func pointForY(y: Double) -> CGFloat {
        let height = bounds.size.height
        return height/2 - CGFloat(y*scaleY)
    }
    
    
}