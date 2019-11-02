//
//  ViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 10/29/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    let healthStore = HKHealthStore()
    @IBOutlet weak var totalMilesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalMilesLabel.text = "0"
        authorizeHealthKit { () in
            
            self.getWorkouts { (result: Double) in

                DispatchQueue.main.async {
                    self.totalMilesLabel.text = "\(Int(result))"
                }
            }
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
    func getWorkouts(completion: @escaping (Double) -> Void) {
        
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        
        let query = HKSampleQuery(sampleType: HKSampleType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
            (query: HKSampleQuery, results: [HKSample]!, error) -> Void in
            var total = 0.0
            for r in results {
                guard let result: HKWorkout = r as? HKWorkout else {
                    return
                }
                let year = Calendar.current.component(.year, from: result.startDate)
                let currentYear = Calendar.current.component(.year, from: Date())
                if year == currentYear {
                    total += result.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0.0
                }
                
            }
            DispatchQueue.main.async {
                completion(total)
            }
            
        })
        
        healthStore.execute(query)
    }


}

