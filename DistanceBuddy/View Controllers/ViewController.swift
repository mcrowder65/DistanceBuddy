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
    var handle: AuthStateDidChangeListenerHandle?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { _, _ in
            if Auth.auth().currentUser != nil {
                let newBtn = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(self.signout))
                self.navigationItem.leftItemsSupplementBackButton = true
                self.navigationItem.leftBarButtonItem = newBtn
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.add))
            } else {
                let newBtn = UIBarButtonItem(title: "Login/Signup", style: .plain, target: self, action: #selector(self.goToLoginSignup))
                self.navigationItem.leftItemsSupplementBackButton = true
                self.navigationItem.leftBarButtonItem = newBtn
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)

        Auth.auth().removeStateDidChangeListener(handle!)
    }

    @objc func goToLoginSignup() {
        let storyboard: UIStoryboard = UIStoryboard(name: "LoginAndSignup", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "MainLoginSignupStoryboard") as? UINavigationController {
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }

    @objc func signout() {
        do {
            try Auth.auth().signOut()

        } catch {
            print("something went wrong while signing out!")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func add() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DistanceVC") as? UINavigationController {
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "totalMileage" {
            let vc: MileageTableViewController = (segue.destination as? MileageTableViewController)!
            table = vc
        }
    }
}
