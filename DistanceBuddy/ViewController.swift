//
//  ViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 10/29/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit
import HealthKit
import SwiftDate


class ViewController: UIViewController {
    var table: MileageTableViewController?
    let healthStore = HKHealthStore()
    var running: DefaultCell = DefaultCell(year: 0, month: 0, week: 0) {
        didSet {
            self.table?.running = self.running
        }
    }
    var walking: DefaultCell = DefaultCell(year: 0, month: 0, week: 0) {
        didSet {
            self.table?.walking = self.walking
        }
    }
    var biking: DefaultCell = DefaultCell(year: 0, month: 0, week: 0) {
        didSet {
            self.table?.biking = self.biking
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit { () in
            self.getWorkouts(type: .running, completion: { (running: DefaultCell) in
                DispatchQueue.main.async {
                    self.running = running
                }
            })
            self.getWorkouts(type: .walking, completion: { (walking: DefaultCell) in
                DispatchQueue.main.async {
                    self.walking = walking
                }
            })
            self.getWorkouts(type: .cycling, completion: { (biking: DefaultCell) in
                DispatchQueue.main.async {
                    self.biking = biking
                }
            })
        }
    }
    
    private func authorizeHealthKit(completion: @escaping () -> Void) {
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

    func getWorkouts(type: HKWorkoutActivityType, completion: @escaping (DefaultCell) -> Void) {
        let predicate = HKQuery.predicateForWorkouts(with: type)
        
        let query = HKSampleQuery(sampleType: HKSampleType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
            (query: HKSampleQuery, results: [HKSample]!, error) -> Void in
            let object: DefaultCell = DefaultCell(year: 0, month: 0, week: 0)
            for r in results {
                guard let result: HKWorkout = r as? HKWorkout else {
                    return
                }
                let value = result.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0.0
                if result.startDate.compare(.isThisYear) {
                    object.year = object.year + value
                }
                if result.startDate.compare(.isThisMonth) {
                    object.month = object.month + value
                }
                if  result.startDate.compare(.isThisWeek) {
                    object.week = object.week + value
                }
            }
            DispatchQueue.main.async {
                completion(object)
            }
        })
        
        healthStore.execute(query)
    }

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "totalMileage" {
                let vc: MileageTableViewController = segue.destination as! MileageTableViewController
                self.table = vc
            }
        }
}

