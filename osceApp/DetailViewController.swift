//
//  DetailViewController.swift
//  osceApp
//
//  Created by Daniel Bronsema on 25/11/2014.
//  Copyright (c) 2014 Dan Bronsema. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTextField: UITextView!
    // Variables
    var selectedProcedure : NSDictionary!
    
    // Outlets

    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if let detailText = selectedProcedure["description"] as? String {
            detailTextField.text = detailText
            detailTextField.selectable = false
        }
        self.title = selectedProcedure["name"]!.capitalizedString
        
        let image = UIImageView(image: UIImage(named: "icon"))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
