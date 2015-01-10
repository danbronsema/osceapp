//
//  checkboxes.swift
//  osceApp
//
//  Created by Daniel Bronsema on 29/11/2014.
//  Copyright (c) 2014 Dan Bronsema. All rights reserved.
//

import Foundation
import UIKit


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

func getGroupByIndexPath(examination: NSMutableDictionary, examinationGroupIndex: Int) -> NSMutableDictionary {
    var group : NSMutableDictionary?
    if let selectedExamination = examination["examinationGroups"] as? NSMutableArray {
        if let selectedGroup = selectedExamination[examinationGroupIndex] as? NSMutableDictionary {
            group = selectedGroup
        }
    }
    return group!
}

func resetAllProcedures(examination: NSMutableDictionary) {
    var procedures : [NSMutableDictionary]!
    if let groupsArray = examination["examinationGroups"] as? NSMutableArray {
        for (index, group) in enumerate(groupsArray) {
            if let procedureArray = group["procedures"] as? NSMutableArray {
                for procedure in procedureArray {
                    if let procedure = procedure as? NSMutableDictionary {
                        procedure["isChecked"] = false
                    }
                }
            }
        }
    }
}

func getTotalNumberOfProceduresAndScore(examination: NSMutableDictionary) -> (Float, Float) {
    var totalProcedures : Float = 0.0
    var totalScore : Float =  0.0
    var procedures : [NSMutableDictionary]!
    if let groupsArray = examination["examinationGroups"] as? NSMutableArray {
        for (index, group) in enumerate(groupsArray) {
            if let procedureArray = group["procedures"] as? NSMutableArray {
                for procedure in procedureArray {
                    if let procedure = procedure as? NSMutableDictionary {
                        totalProcedures += 1
                        if procedure["isChecked"] as Bool == true {
                            totalScore += 1
                        }
                    }
                }
            }
        }
    }
return (totalProcedures, totalScore)
}





