//
//  AddDistanceDelegate.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/3/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import Foundation

protocol AddDistanceDelegate: class {
    func distanceWasAdded(description: String, startDate: Date, endDate: Date?, workoutTypes: [WorkoutTypeModel])
}
