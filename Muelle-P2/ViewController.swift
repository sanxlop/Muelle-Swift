//
//  ViewController.swift
//  Muelle-P2
//
//  Created by sanxlop on 7/10/15.
//  Copyright © 2015 UPM. All rights reserved.
//

import UIKit


class ViewController: UIViewController, MuelleViewDataSource{
    
    @IBOutlet weak var masaSlider: UISlider!
    @IBOutlet weak var kSlider: UISlider!
    @IBOutlet weak var landaSlider: UISlider!
    
    @IBOutlet weak var masaValue: UILabel!
    @IBOutlet weak var kValue: UILabel!
    @IBOutlet weak var landaValue: UILabel!
    
    @IBOutlet weak var posTimeMuelleView: MuelleView!
    @IBOutlet weak var velTimeMuelleView: MuelleView!
    @IBOutlet weak var velPosMuelleView: MuelleView!
    
    var muelleModel: MuelleModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        muelleModel = MuelleModel()
        
        posTimeMuelleView.dataSource = self
        velTimeMuelleView.dataSource = self
        velPosMuelleView.dataSource = self
        
        posTimeMuelleView.scaleX = 30.0
        posTimeMuelleView.scaleY = 15.0
        
        velTimeMuelleView.scaleX = 30.0
        velTimeMuelleView.scaleY = 2.0
        
        velPosMuelleView.scaleX = 25.0
        velPosMuelleView.scaleY = 3.0
        
        
        masaSlider.sendActionsForControlEvents(.ValueChanged)
        kSlider.sendActionsForControlEvents(.ValueChanged)
        landaSlider.sendActionsForControlEvents(.ValueChanged)
        
    }
    
    //MARK: IB Actions
    
    @IBAction func masaChanged(sender: UISlider) {
        
        muelleModel.m = Double(sender.value)
        
        masaValue.text = String(format: "%.1f gr", arguments: [sender.value])
        
        posTimeMuelleView.setNeedsDisplay()
        velTimeMuelleView.setNeedsDisplay()
        velPosMuelleView.setNeedsDisplay()
        
    }
    
    @IBAction func kChanged(sender: UISlider) {
        
        muelleModel.k = Double(sender.value)
        
        kValue.text = String(format: "%.1f gr/s^2", arguments: [sender.value])
        
        posTimeMuelleView.setNeedsDisplay()
        velTimeMuelleView.setNeedsDisplay()
        velPosMuelleView.setNeedsDisplay()
        
    }
    
    @IBAction func landaChanged(sender: UISlider) {
        
        muelleModel.λ = Double(sender.value)
        
        landaValue.text = String(format: "%.1f gr/s", arguments: [sender.value])
        
        posTimeMuelleView.setNeedsDisplay()
        velTimeMuelleView.setNeedsDisplay()
        velPosMuelleView.setNeedsDisplay()
        
    }
    
    
    //MARK: MuelleViewDataSource
    
    func startTimeOfMuelleView(muelleView: MuelleView) -> Double {
        return 0
    }
    
    func endTimeOfMuelleView(muelleView: MuelleView) -> Double {
        return 5
    }
    
    func textOfMuelleView(muelleView: MuelleView) -> String {
        switch muelleView {
        case posTimeMuelleView:
            return "Posicion/Tiempo"
        case velTimeMuelleView:
            return "Velocidad/Tiempo"
        case velPosMuelleView:
            return "Velocidad/Posicion"
        default:
            return "Default"
        }
    }
    
    func positionOfMuelleView(muelleView: MuelleView, atTime time: Double) -> Point {
        
        switch muelleView {
            case posTimeMuelleView:
                let px = time
                let py = muelleModel.posAtTime(time)
                return Point(x: px, y: py)
            case velTimeMuelleView:
                let px = time
                let py = muelleModel.velAtTime(time)
                return Point(x: px, y: py)
            case velPosMuelleView:
                let px = muelleModel.posAtTime(time)
                let py = muelleModel.velAtTime(time)
                return Point(x: px, y: py)
            default:
                return Point(x: 0.0, y: 0.0)
        }
        
    }
    
    @IBAction func zoom(sender: UIPinchGestureRecognizer) {
            velPosMuelleView.scaleX *= Double(sender.scale)
            velPosMuelleView.scaleY *= Double(sender.scale)
            sender.scale = 1
    }
    
    @IBAction func reset(sender: UILongPressGestureRecognizer) {
            velPosMuelleView.scaleX = 25.0
            velPosMuelleView.scaleY = 3.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


