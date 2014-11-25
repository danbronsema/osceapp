//
//  ExaminationTableViewCell.swift
//  osceApp
//
//  Created by Daniel Bronsema on 25/11/2014.
//  Copyright (c) 2014 Dan Bronsema. All rights reserved.
//

import UIKit

class ExaminationTableViewCell: UITableViewCell {

    @IBOutlet weak var procedureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
