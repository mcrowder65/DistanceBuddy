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
import Promises
import CoreData

class ViewController: UIViewController, AddDistanceDelegate {
    func distanceWasAdded(description: String, startDate: Date, endDate: Date?, workoutTypes: [WorkoutTypeModel]) {
        let mileage = MileageModel(
            title: description,
            workoutTypes: workoutTypes,
            startDate: startDate,
            endDate: endDate ?? nil
        )
        self.save(mileage)
    }
    func save(_ mileage: MileageModel) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      let managedContext = appDelegate.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "Mileage",
                                   in: managedContext)!
      
      let data = NSManagedObject(entity: entity, insertInto: managedContext)

      data.setValue(mileage.title, forKeyPath: "title")
      data.setValue(mileage.workoutTypesAsString(), forKeyPath: "workoutTypes")
      data.setValue(mileage.startDate, forKeyPath: "startDate")
      data.setValue(mileage.endDate, forKeyPath: "endDate")
      
      do {
        try managedContext.save()
        self.table?.cells.append(data)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }

    var table: MileageTableViewController?
    var addDistance: AddDistanceViewController?
    
    let healthStore = HKHealthStore()
    var running: DefaultCellModel = DefaultCellModel(title: "Running Distance", year: 0, month: 0, week: 0) {
        didSet {
            self.table?.running = self.running
        }
    }
    var walking: DefaultCellModel = DefaultCellModel(title: "Walking Distance", year: 0, month: 0, week: 0) {
        didSet {
            self.table?.walking = self.walking
        }
    }
    var cycling: DefaultCellModel = DefaultCellModel(title: "Cycling Distance", year: 0, month: 0, week: 0) {
        didSet {
            self.table?.cycling = self.cycling
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit { () in
            self.getWorkouts(type: .running, completion: { (running: DefaultCellModel, walking: DefaultCellModel, cycling: DefaultCellModel) in
                DispatchQueue.main.async {
                    self.running = running
                    self.walking = walking
                    self.cycling = cycling
                }
            })
        }
    }
    
    func getWorkouts(type: HKWorkoutActivityType, completion: @escaping (DefaultCellModel, DefaultCellModel, DefaultCellModel) -> Void) {
        let running = DefaultCellModel(title: "Running Distance", year: 0, month: 0, week: 0)
        let walking = DefaultCellModel(title: "Walking Distance", year: 0, month: 0, week: 0)
        let cycling = DefaultCellModel(title: "Cycling Distance", year: 0, month: 0, week: 0)
        let query = HKSampleQuery(
            sampleType: HKSampleType.workoutType(),
            predicate: nil,
            limit: 0,
            sortDescriptors: nil, resultsHandler: { (_: HKSampleQuery, results: [HKSample]!, _) -> Void in
            for r in results {
                guard let result: HKWorkout = r as? HKWorkout else {
                    return
                }
                let value = result.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0.0
               
                if result.startDate.compare(.isThisYear) {
                    if result.workoutActivityType == .running {
                        running.year += value
                    }
                    if result.workoutActivityType == .walking {
                        walking.year += value
                    }
                    if result.workoutActivityType == .cycling {
                        cycling.year += value
                    }
                }
                if result.startDate.compare(.isThisMonth) {
                    if result.workoutActivityType == .running {
                        running.month += value
                    }
                    if result.workoutActivityType == .walking {
                        walking.month += value
                    }
                    if result.workoutActivityType == .cycling {
                        cycling.month += value
                    }
                }
                if  result.startDate.compare(.isThisWeek) {
                    if result.workoutActivityType == .running {
                        running.week += value
                    }
                    if result.workoutActivityType == .walking {
                        walking.week += value
                    }
                    if result.workoutActivityType == .cycling {
                        cycling.week += value
                    }
                }
            }
            DispatchQueue.main.async {
                completion(running, walking, cycling)
            }
        })
        
        healthStore.execute(query)
    }

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "totalMileage" {
                let vc: MileageTableViewController = (segue.destination as? MileageTableViewController)!
                self.table = vc
            } else if segue.identifier == "addDistance" {
                if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? AddDistanceViewController {
                    targetController.delegate = self
                }
            }
    }
}
