//
//  WorkoutTypeModel.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/4/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import Foundation

class WorkoutTypeModel {
    var title: String
    var status: Bool
    var index: Int
    init(title: String, status: Bool, index: Int) {
        self.title = title
        self.status = status
        self.index = index
    }
}
