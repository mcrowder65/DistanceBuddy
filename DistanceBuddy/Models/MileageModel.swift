//
//  Mileage.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/2/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import CoreData
import Foundation
import Promises

class MileageModel {
    var title: String
    var workoutTypes: [WorkoutTypeModel]
    var startDate: Date
    var endDate: Date?
    var miles: String?
    init(title: String, workoutTypes: [WorkoutTypeModel], startDate: Date, endDate: Date? = Date()) {
        self.title = title
        self.workoutTypes = workoutTypes
        self.startDate = startDate
        self.endDate = endDate
    }

    init(_ nsManagedObject: NSManagedObject) {
        title = nsManagedObject.value(forKeyPath: "title") as? String ?? "Title was nil"
        startDate = nsManagedObject.value(forKeyPath: "startDate") as? Date ?? Date()
        endDate = nsManagedObject.value(forKeyPath: "endDate") as? Date ?? nil
        workoutTypes = (nsManagedObject.value(forKeyPath: "workoutTypes") as? String)?
            .components(separatedBy: ",")
            .enumerated()
            .map { index, element in
                WorkoutTypeModel(title: element, status: true, index: index)
            } ?? []
        miles = nsManagedObject.value(forKeyPath: "miles") as? String
    }

    func asTableViewCell(_ cell: MileageTableViewCell) -> MileageTableViewCell {
        cell.titleLabel?.text = title
        cell.startDateLabel?.text = dateToText(startDate)
        if endDate != nil {
            cell.endDateLabel?.text = dateToText(endDate)
        } else {
            cell.endDateLabel?.text = "Today"
        }

        cell.milesLabel?.text = miles
        return cell
    }

    func workoutTypesAsString() -> String {
        return workoutTypes.map { $0.title }.joined(separator: ",")
    }

    func getMiles(completion: @escaping (String) -> Void) {
        all(
            workoutTypes.map({ (WorkoutTypeModel) -> Promise<Double> in
                Promise<Double> { fulfill, _ in
                    getCustomWorkout(
                        type: getWorkoutType(for: WorkoutTypeModel.title),
                        startDate: self.startDate,
                        endDate: self.endDate,
                        completion: { Double in fulfill(Double) }
                    )
                }
            }
        )).then { results in
            let miles = results.reduce(0) { (accum, r) -> Double in
                accum + r
            }
            completion(String(Int(miles)))
        }
    }
}