//
//  data.swift
//  osceApp
//
//  Created by Daniel Bronsema on 24/11/2014.
//  Copyright (c) 2014 Dan Bronsema. All rights reserved.
//

import Foundation

func loadData(pathName:String) -> NSMutableArray {
    var loadedDataPlist : NSMutableArray?
    
    let path = NSBundle.mainBundle().pathForResource(pathName, ofType: "plist")
    if let data = NSMutableArray(contentsOfFile: path!) {
        loadedDataPlist = data
    }
    return loadedDataPlist!
}

