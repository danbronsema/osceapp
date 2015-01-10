//
//  AppConstants.swift
//  osceApp
//
//  Created by Daniel Bronsema on 29/11/2014.
//  Copyright (c) 2014 Dan Bronsema. All rights reserved.
//

import Foundation

class AppConstants {
    var time : Double
    init(time: Double) {
        self.time = 480
    }
    func timeInMunites() -> Int {
        return Int(self.time)/60
    }
}
var appDefaults = AppConstants(time: 480)
