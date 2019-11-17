//
//  WorkoutTypeTableViewCell.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/4/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit

class WorkoutTypeTableViewCell: UITableViewCell {
    weak var delegate: WorkoutTypeDelegate!
    var cell: WorkoutTypeModel!
    @IBOutlet weak var workoutTitle: UILabel!
    @IBOutlet weak var workoutTypeStatus: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    @IBAction func workoutTypeStatusChanged(_ sender: UISwitch) {
        workoutTypeStatus.setOn(sender.isOn, animated: true)
        self.delegate.statusChangedForCell(
            cell: WorkoutTypeModel(title: self.cell.title, status: sender.isOn, index: self.cell.index)
        )
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
