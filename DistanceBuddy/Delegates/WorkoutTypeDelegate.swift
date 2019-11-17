//
//  WorkoutTypeDelegate.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/4/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import Foundation

protocol WorkoutTypeDelegate: class {
    func statusChangedForCell(cell: WorkoutTypeModel)
}
