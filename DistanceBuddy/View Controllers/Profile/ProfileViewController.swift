//
//  ProfileViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 12/13/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let newBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = newBtn
        // Do any additional setup after loading the view.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
