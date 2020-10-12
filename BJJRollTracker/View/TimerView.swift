//
//  TimerView.swift
//  BJJRollTracker
//
//  Created by Hasan Qasim on 23/9/20.
//  Copyright © 2020 Hasan Qasim. All rights reserved.
//

import UIKit

class TimerView: UIView {
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    var textLayer: CATextLayer?


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func createTextLayer(rect: CGRect, textColor: CGColor) -> CATextLayer {
        let width = rect.width
        let height = rect.height
        
        let fontSize = min(width, height) / 4
        let offset = min(width, height) * 0.1
        
        let layer = CATextLayer()
        layer.string = "01:00"
        layer.foregroundColor = textColor
        layer.fontSize = fontSize
        layer.frame = CGRect(x: 0, y: (height-fontSize-offset)/2, width: width, height: fontSize + offset)
        layer.alignmentMode = .center
        return layer
    }


}



