//
//  ExaminationViewController.swift
//  osceApp
//
//  Created by Daniel Bronsema on 25/11/2014.
//  Copyright (c) 2014 Dan Bronsema. All rights reserved.
//

import UIKit

class ExaminationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBAction func finshedExamButton(sender: AnyObject) {
        displayExaminationScore()
    }
    
    @IBOutlet weak var tableView: UITableView!
    var currentExamination : NSMutableDictionary!
    var examinationCount = 0
    var runningScore = 0
    var selectedProcedure : NSDictionary?
    
    @IBAction func cellButtonPressed(sender: UIButton) {
        println("pressed the \(sender.titleLabel!.text!)")
        if sender.titleLabel!.text! == "NO" {
            sender.setTitle("YES", forState: .Normal)
            runningScore += 1
        } else {
            sender.setTitle("NO", forState: .Normal)
            runningScore -= 1
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        startGame()
    }
    
    
    @IBAction func descriptionButton(sender: AnyObject) {
        let buttonPosition :CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath :NSIndexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)!
        var procedure : AnyObject?
        if let examinationGroup = currentExamination["examinationGroups"]![indexPath.section] as? NSMutableDictionary {
            procedure = examinationGroup["procedures"]
        }
        procedure = procedure![indexPath.row]
        self.selectedProcedure = procedure as? NSDictionary
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
    
    @IBOutlet weak var timerBackground: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let color = currentExamination["color"] as? String {
            self.navigationController?.navigationBar.barTintColor = themeColors[color]
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)            
            self.timerBackground.backgroundColor = themeColors[color]
        }
        if let examTitle = currentExamination["name"] as? String {
            self.title = examTitle.capitalizedString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        
        if let procedureText = procedure!["name"] as? String {
            cell.procedureLabel.text = procedureText

        }
        examinationCount += 1
        return cell
    }

    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailView = segue.destinationViewController as DetailViewController
        detailView.selectedProcedure = selectedProcedure
    }
    
    
    
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var gameTime:Double = 12

    func startGame() {
        
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
    }
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime = currentTime - startTime
        var seconds = gameTime-elapsedTime
        if seconds > 0 {
            elapsedTime -= NSTimeInterval(seconds)
            println("\(Int(seconds))")
        } else {
            timer.invalidate()
        }
    }

    
    
    
    
    
    
    
    
    


}
