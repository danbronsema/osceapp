//
//  CategoryViewController.swift
//  osceApp
//
//  Created by Daniel Bronsema on 24/11/2014.
//  Copyright (c) 2014 Dan Bronsema. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var data : NSMutableArray!

    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.490, green:0.490,
            blue:0.553, alpha: 1)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.data = loadData("data")

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as CategoryTableViewCell
        if let name = self.data[indexPath.row]["name"] as? String {
            cell.cellLabel.text = name.capitalizedString
        }        
        if let color = self.data[indexPath.row]["color"] as? String {
            cell.cellBackgroundFull.backgroundColor = themeColors[color]
        }
    return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        var examinationView = segue.destinationViewController as ExaminationViewController
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow() {
            if let selectedExamination = self.data[indexPath.row] as? NSMutableDictionary {
                examinationView.currentExamination = selectedExamination
            }
        }
        
    }
    

    
    
    
    
    
    

}
