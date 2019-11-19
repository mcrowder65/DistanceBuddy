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

class ViewController: UIViewController {
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
        }
    }
}
