//
//  ExaminationViewController.swift
//  osceApp
//
//  Created by Daniel Bronsema on 25/11/2014.
//  Copyright (c) 2014 Dan Bronsema. All rights reserved.
//

import UIKit

class ExaminationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate  {

    
    
    /* ----------------------------------------- */
    // VARIABLES
    /* ----------------------------------------- */

    var currentExamination : NSMutableDictionary!
    var currentExaminationName: String?
    var currentExaminationColor: UIColor?
    var currentExaminationProcedures : NSMutableArray?

    var selectedProcedure : NSDictionary?
    var timerValues = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    var selectedTimeInSeconds : Double = appDefaults.time
    
    /* ----------------------------------------- */
    // OUTLETS
    /* ----------------------------------------- */

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timerBackground: UIView!
    @IBOutlet weak var timerPicker: UIPickerView!
    @IBOutlet weak var dropDownPickerView: UIView!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishBottomButton: UIButton!
    
    /* ----------------------------------------- */
    // ACTIONS
    /* ----------------------------------------- */

    @IBAction func finishedExaminationButton(sender: AnyObject) {
        self.finishedButton.hidden = true
        self.startButton.hidden = false
        resetTimer()
        displayExaminationScore()
    }

    @IBAction func timerButton(sender: AnyObject) {
        self.finishedButton.hidden = true
        self.startButton.hidden = false
        appDefaults.time = self.selectedTimeInSeconds
        resetTimer()
        springWithCompletion(0.15, { () -> Void in
            self.TimerCount.transform = CGAffineTransformMakeScale(1.05, 1.05)
        }) { (bool) -> Void in
            resetLabelSize(self.TimerCount)
        }
    }
    
    @IBAction func selectTimeDuration(sender: AnyObject) {
        // REVEAL
        if self.dropDownPickerView.hidden == true {
            self.dropDownPickerView.hidden = false
            spring(0.4, { () -> Void in
                self.dropDownPickerView.transform = CGAffineTransformMakeTranslation(0, 220)
            })
        } else {
        // HIDE
            springWithCompletion(0.4, { () -> Void in
                self.dropDownPickerView.transform = CGAffineTransformMakeTranslation(0, -10)
            }, { (finished) -> Void in
                self.dropDownPickerView.hidden = true
            })
        }
    }
    
    
    @IBAction func cellButtonPressed(sender: UIButton) {
        sender.alpha = 1.0
        let indexPath = getSelectedIndexPathAtPoint(sender, self.tableView)
        var selectedProcedure = getProcedureByIndexPath(currentExamination, indexPath.section, indexPath.row)
        if selectedProcedure["isChecked"] as Bool == false {
            selectedProcedure["isChecked"] = true
            sender.transform = CGAffineTransformMakeScale(0.3, 0.3)
            let origImage = UIImage(named: "circle-checked-icon")
            let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            sender.setImage(tintedImage, forState: .Normal)
            sender.tintColor = self.currentExaminationColor
            sender.alpha = 0
            UIView.animateWithDuration(0.15, delay: 0, options: nil, animations: { () -> Void in
            sender.alpha = 1.0
                sender.transform = CGAffineTransformMakeScale(1.4, 1.4)
                }, completion: { (Bool) -> Void in
                resetButtonSize(sender)
            })
        } else  {
            selectedProcedure["isChecked"] = false
            let origImage = UIImage(named: "circle-icon")
            let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            sender.alpha = 0.15
            sender.setImage(tintedImage, forState: .Normal)
            sender.tintColor = UIColor.blackColor()
        }

    }
    
    @IBAction func descriptionButton(sender: AnyObject) {
        let indexPath = getSelectedIndexPathAtPoint(sender, self.tableView)
        selectedProcedure = getProcedureByIndexPath(currentExamination, indexPath.section, indexPath.row)
        performSegueWithIdentifier("detail", sender: self)
    }
    
    func displayExaminationScore() {
        performSegueWithIdentifier("score", sender: self)
    }

    /* ----------------------------------------- */
    // VIEW LOAD TRIGGERS
    /* ----------------------------------------- */

    override func viewWillDisappear(animated: Bool) {
        if self.isMovingFromParentViewController() {
            resetTimer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var timeInMinutes = appDefaults.time/60
        self.TimerCount.text = "\(Int(timeInMinutes)):00"
        self.timerPicker.selectRow(Int(timeInMinutes-1), inComponent: 0, animated: false)
    
    // SET UP START TIMER BUTTON
    //        
        self.finishedButton.hidden = true
        self.startButton.hidden = false
        
    // SET UP CURRENT EXAMINATION COLORS
    //
        self.title = self.currentExaminationName?.capitalizedString
        self.navigationController?.navigationBar.barTintColor = self.currentExaminationColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.timerBackground.backgroundColor = self.currentExaminationColor
        self.dropDownPickerView.backgroundColor = UIColor(red:0.275, green:0.275, blue:0.349, alpha: 1)
        self.timerBackground.layer.shadowOpacity = 0.3;
        self.timerBackground.layer.shadowRadius = 3.0;
        self.timerBackground.layer.shadowColor = UIColor.blackColor().CGColor;
        self.timerBackground.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.finishBottomButton.setTitleColor(currentExaminationColor, forState: UIControlState.Normal)
        
        
    // RESET PROCEDURES
    //
        resetAllProcedures(currentExamination)
    
    }
    
    /* ----------------------------------------- */
    // TABLEVIEW
    /* ----------------------------------------- */

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentExamination["examinationGroups"]!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberCount : Int?
        if let examinationGroup = currentExamination["examinationGroups"]![section] as? NSMutableDictionary {
            numberCount = examinationGroup["procedures"]!.count
        }
        return numberCount!
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customExaminationCell", forIndexPath: indexPath) as ExaminationTableViewCell

        var procedure = getProcedureByIndexPath(currentExamination, indexPath.section, indexPath.row)

        cell.procedureLabel.text = procedure["name"] as? String

        let origImage = UIImage(named: "circle-icon")
        let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        if procedure["isChecked"] as Bool == true {
            let checkOrigImage = UIImage(named: "circle-checked-icon")
            let CheckTintedImage = checkOrigImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.checkButton.setImage(CheckTintedImage, forState: .Normal)
            cell.checkButton.tintColor = self.currentExaminationColor
            cell.checkButton.alpha = 1.00

        } else {
            cell.checkButton.alpha = 0.15
            cell.checkButton.setImage(tintedImage, forState: .Normal)
            cell.checkButton.tintColor = UIColor.blackColor()
            
        }
        
        let nextImage = UIImage(named: "next-icon")
        let nextTintedImage = nextImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.detailButton.setImage(nextTintedImage, forState: .Normal)
        cell.detailButton.tintColor = UIColor.blackColor()
        cell.detailButton.alpha = 0.15

        return cell

    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group = getGroupByIndexPath(currentExamination, section)
        var title =  group["groupTitle"] as? String
        return title
    }

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        header.textLabel.textColor = UIColor.blackColor()
        header.textLabel.alpha = 0.50
        header.textLabel.font = UIFont.boldSystemFontOfSize(14)
    }
    
    
    /* ----------------------------------------- */
    // TIMER
    /* ----------------------------------------- */

    @IBOutlet weak var TimerCount: UILabel!

    var startTime = NSDate()
    var timer = NSTimer()
    var totalCountDownTimeInterval : NSTimeInterval?

    func updateTime() {
        totalCountDownTimeInterval = NSTimeInterval(appDefaults.time)
        var elapsedTime : NSTimeInterval  = NSDate().timeIntervalSinceDate(startTime)
        var remainingTime : NSTimeInterval = totalCountDownTimeInterval! - elapsedTime
        if remainingTime <= 0.0 {
            timer.invalidate()
            displayExaminationScore()
            resetTimer()
            return
        }
        let minutes = UInt8(remainingTime / 60.0)
        remainingTime = remainingTime - (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(remainingTime)
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)

        println("\(minutes):\(strSeconds)")
        TimerCount.text = "\(minutes):\(strSeconds)"
    }

    @IBAction func StartButton(sender: AnyObject) {
        self.finishedButton.hidden = false
        self.startButton.hidden = true
        resetTimer()
        startTime = NSDate()
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.10, target: self, selector: aSelector, userInfo: nil, repeats: true)
    }
    
    
    
    @IBAction func StopButton(sender: AnyObject) {
        timer.invalidate()
    }

    func resetTimer() {
        timer.invalidate()
        var timeInMinutes = appDefaults.time/60
        self.TimerCount.text = "\(Int(timeInMinutes)):00"
    }

    /* ----------------------------------------- */
    // PICKER TIMER
    /* ----------------------------------------- */

    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timerValues.count
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var value = timerValues[row]
        return String(value)
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var value = timerValues[row]
        var valueString = String(value)
        let attributedString = NSAttributedString(string: valueString, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        return attributedString
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedTimeInSeconds = Double((row + 1) * 60)
    }
    
    /* ----------------------------------------- */
    // SEGUE
    /* ----------------------------------------- */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            var detailView = segue.destinationViewController as DetailViewController
            detailView.selectedProcedure = selectedProcedure
        } else {
            var examinationCompleteView = segue.destinationViewController as ExaminationCompleteViewController
            examinationCompleteView.currentExamination = currentExamination
            examinationCompleteView.currentExaminationColor = currentExaminationColor
            examinationCompleteView.currentExaminationName = currentExaminationName
            examinationCompleteView.currentExaminationProcedures = currentExaminationProcedures
            let (procedureCount, totalScore) = getTotalNumberOfProceduresAndScore(currentExamination)
            println("There were \(procedureCount) and the score was \(totalScore)")
            let score = (totalScore / procedureCount) * 100
            examinationCompleteView.currentExaminationScore = Int(score)
        }
    }
    


}
