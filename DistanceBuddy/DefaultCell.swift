//
//  DefaultCell.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/2/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import Foundation
class DefaultCell {
    var year: Double = 0
    var month: Double = 0
    var week: Double = 0
    func toString() -> String {
        return "Year: \(Int(year)) Month: \(Int(month)) Week: \(Int(week))"
    }
    init(year: Double, month: Double, week: Double) {
        self.year = year
        self.month = month
        self.week = week
    }
}
