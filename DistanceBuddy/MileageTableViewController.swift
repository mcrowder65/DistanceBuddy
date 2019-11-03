//
//  MileageTableViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/2/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit

class MileageTableViewController: UITableViewController {
    var running: DefaultCell = DefaultCell(year: 0, month: 0, week: 0) {
        didSet {
            self.cells[0].description = self.running.toString()
            self.tableView.reloadData()
        }
    }
    var walking: DefaultCell = DefaultCell(year: 0, month: 0, week: 0) {
        didSet {
            self.cells[1].description = self.walking.toString()
            self.tableView.reloadData()
        }
    }
    var biking: DefaultCell = DefaultCell(year: 0, month: 0, week: 0) {
        didSet {
            self.cells[2].description = self.biking.toString()
            self.tableView.reloadData()
        }
    }
    var cells: [Mileage]! {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cells = [
            Mileage(title: "Running Distance", description: running.toString()),
            Mileage(title: "Walking Distance", description: walking.toString()),
            Mileage(title: "Biking Distance", description: biking.toString())
       ]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MileageTableViewCell {
        let cellIdentifier = "MileageTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MileageTableViewCell else {
            fatalError("The dequeued cell is not an instance of MileageTableViewCell.")
        }
        
        cell.textLabel?.text = self.cells[indexPath.row].title
        cell.detailTextLabel?.text =  self.cells[indexPath.row].description
        return cell
    }

}
