//
//  MileageTableViewCell.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/2/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit

class MileageTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
