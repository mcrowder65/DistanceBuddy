//
//  DefaultCell.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/2/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import Foundation
import CoreData

class DefaultCellModel {
    var year: Double = 0
    var month: Double = 0
    var week: Double = 0
    var title: String
    init(title: String, year: Double, month: Double, week: Double) {
        self.title = title
        self.year = year
        self.month = month
        self.week = week
    }
    
    func asTableViewCell(_ cell: MileageDefaultTableViewCell) -> MileageDefaultTableViewCell {
        cell.titleLabel?.text = self.title
        cell.yearValueLabel?.text = String(Int(self.year))
        cell.monthValueLabel?.text = String(Int(self.month))
        cell.weekValueLabel?.text = String(Int(self.week))
        return cell
    }
}
