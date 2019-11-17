//
//  ViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 10/29/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import CoreData
import HealthKit
import Promises
import SwiftDate
import UIKit

class ViewController: UIViewController, AddDistanceDelegate {
    func distanceWasAdded(description: String, startDate: Date, endDate: Date?, workoutTypes: [WorkoutTypeModel]) {
        let mileage = MileageModel(
            title: description,
            workoutTypes: workoutTypes,
            startDate: startDate,
            endDate: endDate ?? nil
        )
        save(mileage)
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
            table?.cells.append(data)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    var table: MileageTableViewController?
    var addDistance: AddDistanceViewController?

    var running: DefaultCellModel = DefaultCellModel(title: "Running Distance", year: 0, month: 0, week: 0) {
        didSet {
            table?.running = running
        }
    }

    var walking: DefaultCellModel = DefaultCellModel(title: "Walking Distance", year: 0, month: 0, week: 0) {
        didSet {
            table?.walking = walking
        }
    }

    var cycling: DefaultCellModel = DefaultCellModel(title: "Cycling Distance", year: 0, month: 0, week: 0) {
        didSet {
            self.table?.cycling = self.cycling
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit { _, _ in
            getWorkouts(completion: { (running: DefaultCellModel, walking: DefaultCellModel, cycling: DefaultCellModel) in
                DispatchQueue.main.async {
                    self.running = running
                    self.walking = walking
                    self.cycling = cycling
                }
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "totalMileage" {
            let vc: MileageTableViewController = (segue.destination as? MileageTableViewController)!
            table = vc
        } else if segue.identifier == "addDistance" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? AddDistanceViewController {
                targetController.delegate = self
            }
        }
    }
}
