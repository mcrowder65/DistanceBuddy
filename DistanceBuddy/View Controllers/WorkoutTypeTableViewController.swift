//
//  WorkoutTypeTableViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/4/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit

class WorkoutTypeTableViewController: UITableViewController, WorkoutTypeDelegate {
    func statusChangedForCell(cell: WorkoutTypeModel) {
        cells[cell.index] = cell
        tableView?.reloadData()
    }

    var cells: [WorkoutTypeModel] = [
        WorkoutTypeModel(title: "Running", status: false, index: 0),
        WorkoutTypeModel(title: "Walking", status: false, index: 1),
        WorkoutTypeModel(title: "Cycling", status: false, index: 2),
        WorkoutTypeModel(title: "Hiking", status: false, index: 3),
        WorkoutTypeModel(title: "Rowing", status: false, index: 4),
        WorkoutTypeModel(title: "Swimming", status: false, index: 5),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // This makes it so there are no extra empty cells displayed
        tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> WorkoutTypeTableViewCell {
        let cellIdentifier = "workoutTypeTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkoutTypeTableViewCell else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        cell.workoutTitle?.text = cells[indexPath.row].title
        cell.delegate = self
        cell.cell = cells[indexPath.row]
        cell.setStatus(status: cell.cell.status)
        return cell
    }
}
