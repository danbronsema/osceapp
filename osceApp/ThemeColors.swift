//
//  theme.swift
//  osceApp
//
//  Created by Daniel Bronsema on 24/11/2014.
//  Copyright (c) 2014 Dan Bronsema. All rights reserved.
//

import Foundation
import UIKit


var themeColors : [String:UIColor] = [
    "red" : UIColor(red:0.906, green:0.298, blue:0.231, alpha: 1),
    "blue" : UIColor(red:0.180, green:0.729, blue:1.000, alpha: 1),
    "orange" : UIColor(red:0.961, green:0.651, blue:0.137, alpha: 1),
    "green" : UIColor(red:0.290, green:0.851, blue:0.392, alpha: 1),
    "light-red" : UIColor(red:1.000, green:0.420, blue:0.357, alpha: 1),
    "purple" : UIColor(red:0.545, green:0.518, blue:0.812, alpha: 1)
]


extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        color1.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}