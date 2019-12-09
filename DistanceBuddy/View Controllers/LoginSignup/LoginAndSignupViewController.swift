//
//  LoginAndSignupViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 12/8/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit

class LoginAndSignupViewController: UIViewController {
    @objc func anotherMethod() {
        dismiss(animated: true, completion: nil)
    }

    @objc func signup() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupStoryboard") as? UINavigationController {
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let newBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(anotherMethod))
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = newBtn

        let signupBtn = UIBarButtonItem(title: "Signup", style: .plain, target: self, action: #selector(signup))
        navigationItem.rightBarButtonItem = signupBtn
    }
}
