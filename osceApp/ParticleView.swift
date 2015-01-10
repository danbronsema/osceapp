//
//  ParticleView.swift
//  osceApp
//
//  Created by Daniel Bronsema on 30/11/2014.
//  Copyright (c) 2014 Dan Bronsema. All rights reserved.
//

import UIKit

class ParticleView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    func drawParticles() {

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(15,8), false, 1)
        let con = UIGraphicsGetCurrentContext()
        CGContextAddRect(con, CGRectMake(0, 0, 15, 8))
        CGContextSetFillColorWithColor(con, UIColor.whiteColor().CGColor)
        CGContextFillPath(con)
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // make a cell with that image
        var cell = CAEmitterCell()
        cell.birthRate = 13
        cell.color = UIColor(red:0.5, green:0.5, blue:0.5, alpha:1.0).CGColor
        cell.redRange = 1
        cell.blueRange = 1
        cell.greenRange = 1
        cell.lifetime = 10
        cell.velocity = -100
        cell.spinRange = 10.0
        cell.scale = 1.0;
        cell.scaleRange = 0.2;
        cell.emissionRange = CGFloat(M_PI)/5.0
        cell.contents = im.CGImage
        
        var emit = CAEmitterLayer()
        emit.emitterSize = CGSize(width: 600, height: 0)
        emit.emitterPosition = CGPointMake(0,-150)
        emit.emitterShape = kCAEmitterLayerLine
        emit.emitterMode = kCAEmitterLayerLine

        emit.emitterCells = [cell]
        self.layer.addSublayer(emit)

    }

    
}
