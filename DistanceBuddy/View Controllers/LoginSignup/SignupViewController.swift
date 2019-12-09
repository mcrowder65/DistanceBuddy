//
//  SignupViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 12/8/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import Firebase
import UIKit

class SignupViewController: UIViewController {
    @IBOutlet var emailAddress: UITextField!
    @IBOutlet var password: UITextField!
    @objc func anotherMethod() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let newBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(anotherMethod))
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = newBtn
        // Do any additional setup after loading the view.
    }

    @IBAction func signup(_: Any) {
        if emailAddress?.text?.isEmpty ?? false {
            let alert = UIAlertController(title: "Email address is required", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if !isValidEmail(emailAddress?.text ?? "") {
            let alert = UIAlertController(title: "A valid email address is required", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if password?.text?.isEmpty ?? false {
            let alert = UIAlertController(title: "Password is required", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if let email = emailAddress?.text, let pass = password?.text {
            Auth.auth().createUser(withEmail: email, password: pass) { _, error in
                // ...
                if error != nil {
                    let alert = UIAlertController(title: "An error occurred", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    Auth.auth().signIn(withEmail: email, password: pass) { [weak self] _, error in
                        if error != nil {
                            let alert = UIAlertController(title: "An error occurred", message: error?.localizedDescription, preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(action)
                            self?.present(alert, animated: true, completion: nil)
                        } else {
                            self?.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }

}
