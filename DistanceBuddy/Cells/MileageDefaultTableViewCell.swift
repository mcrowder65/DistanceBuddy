//
//  MileageDefaultTableViewCell.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/6/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit

class MileageDefaultTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearValueLabel: UILabel!
    @IBOutlet var monthValueLabel: UILabel!
    @IBOutlet var weekValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        yearValueLabel?.text = "0"
        monthValueLabel?.text = "0"
        weekValueLabel?.text = "0"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
