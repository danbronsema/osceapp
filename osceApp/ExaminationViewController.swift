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
    var currentExaminationName : String?
    var currentExaminationColor: UIColor?
    var currentExaminationProcedures : NSMutableArray?

    var examinationCount = 0
    var runningScore = 0
    var selectedProcedure : NSDictionary?
    var countdownDuration : Double?
    var timerValues = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    var chosenTimeInMinutes = 8
    var chosenTimeInSeconds = 480

    /* ----------------------------------------- */
    // OUTLETS
    /* ----------------------------------------- */

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timerBackground: UIView!
    @IBOutlet weak var timerPicker: UIPickerView!
    @IBOutlet weak var dropDownPickerView: UIView!
    @IBOutlet weak var timerButton: UIButton!
    
    /* ----------------------------------------- */
    // ACTIONS
    /* ----------------------------------------- */

    @IBAction func timerButton(sender: AnyObject) {
        resetTimer()
        spring(0.3, { () -> Void in
            self.TimerCount.transform = CGAffineTransformMakeScale(1.2, 1.5)
        })
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
    @IBAction func finshedExamButton(sender: AnyObject) {
        resetTimer()
        displayExaminationScore()
    }
    
    @IBAction func cellButtonDown(sender: UIButton) {
        sender.alpha = 0.4
    }
    
    func resetSize(sender: UIButton) {
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: { () -> Void in
            sender.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }, completion: nil)
        
    }
    
    @IBAction func cellButtonPressed(sender: UIButton) {
        sender.alpha = 1.0
        if sender.titleLabel!.text == "NO" {
            sender.transform = CGAffineTransformMakeScale(0.3, 0.3)
            sender.setTitle("YES", forState: .Normal)
            let origImage = UIImage(named: "circle-checked-icon")
            let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            runningScore += 1
            sender.setImage(tintedImage, forState: .Normal)
            sender.tintColor = self.currentExaminationColor
            sender.alpha = 0
            UIView.animateWithDuration(0.15, delay: 0, options: nil, animations: { () -> Void in
            sender.alpha = 1.0
                sender.transform = CGAffineTransformMakeScale(1.4, 1.4)
                }, completion: { (Bool) -> Void in
                self.resetSize(sender)
            })
        
        } else {
            sender.setTitle("NO", forState: .Normal)
            runningScore -= 1
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
        var score = Float(runningScore) / Float(examinationCount)
        var percentage : Int = Int(score * 100)
        if let examTitle = currentExamination["name"] as? String {
            let alertController = UIAlertController(title: "Examination complete!", message: "You \n scored \(percentage)% in the \(examTitle) examination.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    /* ----------------------------------------- */
    // VIEW LOAD TRIGGERS
    /* ----------------------------------------- */
    override func viewDidLoad() {
        super.viewDidLoad()

    // RESET TIMERS
    //
        countdownDuration = 480
        resetTimer()
        timerPicker.selectRow(7, inComponent: 0, animated: false)

    // SET UP CURRENT EXAMINATION COLORS
    //
        
        self.navigationController?.navigationBar.barTintColor = self.currentExaminationColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.timerBackground.backgroundColor = self.currentExaminationColor
        self.dropDownPickerView.backgroundColor = UIColor(red:0.275, green:0.275, blue:0.349, alpha: 1)
        self.timerBackground.layer.shadowOpacity = 0.3;
        self.timerBackground.layer.shadowRadius = 3.0;
        self.timerBackground.layer.shadowColor = UIColor.blackColor().CGColor;
        self.timerBackground.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        var procedure : AnyObject?
        if let examinationGroup = currentExamination["examinationGroups"]![indexPath.section] as? NSMutableDictionary {
            procedure = examinationGroup["procedures"]
        }
        procedure = procedure![indexPath.row]

        let isChecked = procedure!["isChecked"] as Bool
        
        if let procedureText = procedure!["name"] as? String {
            cell.procedureLabel.text = procedureText
        }
        examinationCount += 1
        let origImage = UIImage(named: "circle-icon")
        let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.circleUnchecked.alpha = 0.15
        cell.circleUnchecked.setImage(tintedImage, forState: .Normal)
        cell.circleUnchecked.tintColor = UIColor.blackColor()

//        toggleCheckbox(currentExamination["name"!], indexPath.section, indexPath.row, isChecked)

        
        return cell

        
    }
    
    /* ----------------------------------------- */
    // NAVIGATION
    /* ----------------------------------------- */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailView = segue.destinationViewController as DetailViewController
        detailView.selectedProcedure = selectedProcedure
    }
    
    /* ----------------------------------------- */
    // TIMER
    /* ----------------------------------------- */

    @IBOutlet weak var TimerCount: UILabel!

    var startTime = NSDate()
    var timer = NSTimer()
    var isRunning = false
    var totalCountDownTimeInterval : NSTimeInterval?

    func updateTime() {
        totalCountDownTimeInterval = NSTimeInterval(self.countdownDuration!)
        var elapsedTime : NSTimeInterval  = NSDate().timeIntervalSinceDate(startTime)
        var remainingTime : NSTimeInterval = totalCountDownTimeInterval! - elapsedTime
        if remainingTime <= 0.0 {
            timer.invalidate()
        }
        let minutes = UInt8(remainingTime / 60.0)
        remainingTime = remainingTime - (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(remainingTime)
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)

        println("\(minutes):\(strSeconds)")
        TimerCount.text = "\(minutes):\(strSeconds)"
    }

    @IBAction func StartButton(sender: AnyObject) {
        if !timer.valid {
            startTime = NSDate()
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.10, target: self, selector: aSelector, userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func StopButton(sender: AnyObject) {
        timer.invalidate()
    }

    func resetTimer() {
        timer.invalidate()
        self.countdownDuration = Double(self.chosenTimeInSeconds)
        self.TimerCount.text = "\(self.chosenTimeInMinutes):00"
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
        self.chosenTimeInMinutes = row + 1
        self.chosenTimeInSeconds = (row + 1) * 60
    }
    
    
    
    
    
    
    


}
