//
//  checkboxes.swift
//  osceApp
//
//  Created by Daniel Bronsema on 29/11/2014.
//  Copyright (c) 2014 Dan Bronsema. All rights reserved.
//

import Foundation
import UIKit


func toggleCheckbox(examination:String, section: Int, row: Int, currentStatus: Bool) -> Bool {

    
    
    return true
}

//      resetAllCheckboxes(examination)
//      toggleCheckbox(examination, section, row)
//      getAllProcedures(examination)

func getSelectedIndexPathAtPoint(sender: AnyObject?, tableView : UITableView) -> NSIndexPath {
    let buttonPosition : CGPoint = sender!.convertPoint(CGPointZero, toView: tableView)
    let indexPath : NSIndexPath = tableView.indexPathForRowAtPoint(buttonPosition)!
    return indexPath
}

func getProcedureByIndexPath(examination: NSMutableDictionary, examinationGroupIndex: Int, procedureIndex : Int) -> NSMutableDictionary {
    var procedure : NSMutableDictionary?
    if let selectedExamination = examination["examinationGroups"] as? NSMutableArray {
        let selectedGroup = selectedExamination[examinationGroupIndex] as NSMutableDictionary
        let selectedProcedures = selectedGroup["procedures"] as NSMutableArray
        if let selectedProcedure = selectedProcedures[procedureIndex] as? NSMutableDictionary {
            procedure = selectedProcedure
        }
    }
    return procedure!
}











