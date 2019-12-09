//
//  RouterViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 12/2/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import Firebase
import UIKit

class MainViewController: UIViewController {
    var isLoggedIn: Bool = false
    var handle: AuthStateDidChangeListenerHandle?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { _, _ in
            if Auth.auth().currentUser != nil {
                self.goToMainDistanceStoryboard()
            }
        }
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)

        Auth.auth().removeStateDidChangeListener(handle!)
    }

    func goToMainDistanceStoryboard() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Distance", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "MainDistanceStoryboard") as? UINavigationController {
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func touched(_: Any) {
        goToMainDistanceStoryboard()
    }

    @IBAction func loginSignup(_: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "LoginAndSignup", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "MainLoginSignupStoryboard") as? UINavigationController {
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
