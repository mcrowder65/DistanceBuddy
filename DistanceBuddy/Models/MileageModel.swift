//
//  Mileage.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/2/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import CoreData
import FirebaseFirestore
import Foundation
import Promises
class MileageModel: FirebaseModel {
    var title: String
    var workoutTypes: [WorkoutTypeModel]
    var startDate: Date
    var endDate: Date?
    var miles: String?
    var userId: String?
    var id: String?
    init(title: String, workoutTypes: [WorkoutTypeModel], startDate: Date, endDate: Date? = Date()) {
        self.title = title
        self.workoutTypes = workoutTypes
        self.startDate = startDate
        self.endDate = endDate
    }

    required init(_ fireStoreObject: [String: Any], id: String) {
        title = (fireStoreObject["title"] as! String)
        workoutTypes = MileageModel.workoutTypesAsStringToWorkoutTypes(fireStoreObject["workoutTypes"] as? String ?? "")
        let startDate = fireStoreObject["startDate"] as! Timestamp
        self.startDate = Date(timeIntervalSince1970: TimeInterval(startDate.seconds))
        let endDate = (fireStoreObject["endDate"] as? Timestamp) ?? nil
        if endDate == nil {
            self.endDate = nil
        } else {
            self.endDate = Date(timeIntervalSince1970: TimeInterval(endDate!.seconds))
        }
        userId = fireStoreObject["userId"] as? String
        self.id = id
    }

    func toFirestore() -> [String: Any] {
        return [
            "title": self.title,
            "workoutTypes": workoutTypesAsString(),
            "startDate": startDate,
            "endDate": endDate,
            "userId": "matt",
        ]
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

    private func workoutTypesAsString() -> String {
        return workoutTypes.map { $0.title }.joined(separator: ",")
    }

    static func workoutTypesAsStringToWorkoutTypes(_ workoutTypes: String) -> [WorkoutTypeModel] {
        return workoutTypes.components(separatedBy: ",")
            .enumerated()
            .map { _, element in
                getWorkoutType(for: element, status: true)
            }
    }

    func getMiles(completion: @escaping (String) -> Void) {
        authorizeHealthKit(completion: { _, _ in
            all(
                self.workoutTypes.map({ (WorkoutTypeModel) -> Promise<Double> in
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
        })
    }
}

extension MileageModel: Equatable {
    static func == (lhs: MileageModel, rhs: MileageModel) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.workoutTypesAsString() == rhs.workoutTypesAsString() &&
            lhs.startDate == rhs.startDate &&
            lhs.endDate == rhs.endDate &&
            lhs.miles == rhs.miles &&
            lhs.userId == rhs.userId &&
            lhs.id == rhs.id
    }
}
