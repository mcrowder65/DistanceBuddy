//
//  Utilities.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/5/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import Foundation
import HealthKit
import Promises

private let dateFormat: String = "MM/dd/yyyy"
private let healthStore = HKHealthStore()
func getWorkoutType(for workoutType: String) -> HKWorkoutActivityType {
    if workoutType == "Running" {
        return .running
    } else if workoutType == "Walking" {
        return .walking
    } else if workoutType == "Cycling" {
        return .cycling
    } else if workoutType == "Hiking" {
        return .hiking
    } else if workoutType == "Rowing" {
        return .rowing
    } else if workoutType == "Swimming" {
        return .swimming
    }
    return .running
}

func textToDate(_ text: String?) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    let str = text ?? ""
    let d = str.isEmpty ? Date().toFormat(dateFormat) : str
    guard let selectedDate = dateFormatter.date(from: d) else {
       fatalError()
    }
    return selectedDate
}

func dateToText(_ date: Date?) -> String {
    return (date ?? Date()).toFormat(dateFormat)
}

func authorizeHealthKit(completion: @escaping () -> Void) {
  HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
        
    guard authorized else {
      let baseMessage = "HealthKit Authorization Failed"
      if let error = error {
        print("\(baseMessage). Reason: \(error.localizedDescription)")
      } else {
        print(baseMessage)
      }
      return
    }
    print("HealthKit Successfully Authorized.")
    completion()
  }
}

func getCustomWorkout(type: HKWorkoutActivityType, startDate: Date, endDate: Date?, completion: @escaping (Double) -> Void) {
       let predicate = HKQuery.predicateForWorkouts(with: type)
       
       let query = HKSampleQuery(
           sampleType: HKSampleType.workoutType(),
           predicate: predicate,
           limit: 0,
           sortDescriptors: nil, resultsHandler: { (_: HKSampleQuery, results: [HKSample]!, _) -> Void in
           var distance = 0.0
           for r in results {
               guard let result: HKWorkout = r as? HKWorkout else {
                   return
               }
               let value = result.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0.0
               if result.startDate.isInRange(date: startDate, and: endDate ?? Date()) {
                   distance += value
               }
               
           }
           DispatchQueue.main.async {
               completion(distance)
           }
       })
       
       healthStore.execute(query)
   }

func getWorkouts(completion: @escaping (DefaultCellModel, DefaultCellModel, DefaultCellModel) -> Void) {
    let distances: [[String: Any]] = [
        [ "type": HKWorkoutActivityType.running, "time": "year" ],
        [ "type": HKWorkoutActivityType.running, "time": "month" ],
        [ "type": HKWorkoutActivityType.running, "time": "week" ],
        [ "type": HKWorkoutActivityType.walking, "time": "year" ],
        [ "type": HKWorkoutActivityType.walking, "time": "month" ],
        [ "type": HKWorkoutActivityType.walking, "time": "week" ],
        [ "type": HKWorkoutActivityType.cycling, "time": "year" ],
        [ "type": HKWorkoutActivityType.cycling, "time": "month" ],
        [ "type": HKWorkoutActivityType.cycling, "time": "week" ]
    ]
    Promises.all(
       distances.map({ (Dictionary) -> Promise<Double> in
           return Promise<Double> { fulfill, _ in
               var startDate = Date()
               if Dictionary["time"] as? String == "year" {
                 startDate = Date(year: Date().year, month: 1, day: 1, hour: 0, minute: 0)
               } else if Dictionary["time"] as? String == "month" {
                 startDate = Date(year: Date().year, month: Date().month, day: 1, hour: 0, minute: 0)
               } else if Dictionary["time"] as? String == "week" {
                 startDate = Date(year: Date().year, month: Date().month, day: Date().firstDayOfWeek, hour: 0, minute: 0)
               }
               let type = Dictionary["type"] as! HKWorkoutActivityType
               getCustomWorkout(
                   type: type,
                   startDate: startDate,
                   endDate: Date(),
                   completion: { (Double) in fulfill(Double) }
               )
           }
       }
   )).then { results in
    DispatchQueue.main.async {
        completion(
            DefaultCellModel(title: "Running Distance", year: results[0], month: results[1], week: results[2]),
            DefaultCellModel(title: "Walking Distance", year: results[3], month: results[4], week: results[5]),
            DefaultCellModel(title: "Cycling Distance", year: results[6], month: results[7], week: results[8])
        )
    }
   }
}
