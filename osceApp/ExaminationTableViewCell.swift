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
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
