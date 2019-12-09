//
//  LoginViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 12/8/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import Firebase
import UIKit

class LoginViewController: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?
    @IBOutlet var emailAddress: UITextField!
    @IBOutlet var password: UITextField!
    @IBAction func login(_: Any) {
        Auth.auth().signIn(withEmail: emailAddress?.text ?? "", password: password?.text ?? "") { _, error in
            let alert = UIAlertController(title: "Something went wrong!", message: error?.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { _, _ in
            if Auth.auth().currentUser != nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        Auth.auth().removeStateDidChangeListener(handle!)
    }

    @IBAction func forgotPassword(_: Any) {
        if !isValidEmail(emailAddress?.text ?? "") {
            let alert = UIAlertController(
                title: "Please enter a valid email address into the email address field",
                message: "",
                preferredStyle: .alert
            )
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Reset Password",
                message: "Would you like to receive a reset password email sent to \(String(emailAddress!.text!))?",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                Auth.auth().sendPasswordReset(withEmail: self.emailAddress!.text!, completion: { error in
                    if error != nil {
                        let alert = UIAlertController(
                            title: "An error occurred!",
                            message: error?.localizedDescription,
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(
                            title: "Reset password email sent to \(String(self.emailAddress!.text!))",
                            message: error?.localizedDescription,
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }

                })
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
