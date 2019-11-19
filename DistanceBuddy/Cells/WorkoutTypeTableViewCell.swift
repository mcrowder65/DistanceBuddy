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
    @IBOutlet var workoutTitle: UILabel!
    @IBOutlet var workoutTypeStatus: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setStatus(status: Bool) {
        workoutTypeStatus.setOn(status, animated: false)
    }

    @IBAction func workoutTypeStatusChanged(_ sender: UISwitch) {
        workoutTypeStatus.setOn(sender.isOn, animated: true)
        delegate.statusChangedForCell(
            cell: WorkoutTypeModel(title: cell.title, status: sender.isOn, index: cell.index)
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
