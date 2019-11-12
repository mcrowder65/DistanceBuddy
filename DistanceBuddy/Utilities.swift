//
//  Utilities.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/5/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import Foundation
import HealthKit
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
