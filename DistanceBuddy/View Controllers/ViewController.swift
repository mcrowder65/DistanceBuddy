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
    var addDistance: DistanceViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "totalMileage" {
            let vc: MileageTableViewController = (segue.destination as? MileageTableViewController)!
            table = vc
        }
    }
}
