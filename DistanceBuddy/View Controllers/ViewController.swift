//
//  ViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 10/29/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import CoreData
import Firebase
import HealthKit
import Promises
import SwiftDate
import UIKit

class ViewController: UIViewController {
    var table: MileageTableViewController?
    var addDistance: DistanceViewController?
    @objc func closeSelf() {
        dismiss(animated: true, completion: nil)
    }

    @objc func signout() {
        do {
            try Auth.auth().signOut()
            closeSelf()
        } catch {
            print("something went wrong while signing out!")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil {
            let newBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(closeSelf))
            navigationItem.leftItemsSupplementBackButton = true
            navigationItem.leftBarButtonItem = newBtn

            navigationItem.rightBarButtonItem = nil
        } else {
            let newBtn = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signout))
            navigationItem.leftItemsSupplementBackButton = true
            navigationItem.leftBarButtonItem = newBtn
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "totalMileage" {
            let vc: MileageTableViewController = (segue.destination as? MileageTableViewController)!
            table = vc
        }
    }
}
