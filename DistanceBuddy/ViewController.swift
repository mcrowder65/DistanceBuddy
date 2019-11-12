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
            self.getWorkouts(completion: { (running: DefaultCellModel, walking: DefaultCellModel, cycling: DefaultCellModel) in
                DispatchQueue.main.async {
                    self.running = running
                    self.walking = walking
                    self.cycling = cycling
                }
            })
        }
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
