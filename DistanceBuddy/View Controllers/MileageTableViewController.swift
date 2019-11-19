//
//  MileageTableViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/2/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import CoreData
import FirebaseCore
import FirebaseFirestore
import Promises
import UIKit
class MileageTableViewController: UITableViewController {
    let distanceFao: DistanceFAO = DistanceFAO()
    var db: Firestore!
    var running: DefaultCellModel = DefaultCellModel(title: "Running Distance", year: 0, month: 0, week: 0) {
        didSet {
            defaultCells[0] = running
            tableView.reloadData()
        }
    }

    var walking: DefaultCellModel = DefaultCellModel(title: "Walking Distance", year: 0, month: 0, week: 0) {
        didSet {
            defaultCells[1] = walking
            tableView.reloadData()
        }
    }

    var cycling: DefaultCellModel = DefaultCellModel(title: "Cycling Distance", year: 0, month: 0, week: 0) {
        didSet {
            defaultCells[2] = cycling
            tableView.reloadData()
        }
    }

    var cells: [MileageModel]! = [] {
        didSet {
            tableView.reloadData()
        }
    }

    lazy var defaultCells: [DefaultCellModel] = {
        [
            self.running,
            self.walking,
            self.cycling,
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        distanceFao.subscribe { mileageModels in
            self.cells = mileageModels as? [MileageModel]
            self.getMilesForCustomCells()
        }
        // This makes it so there are no extra empty cells displayed
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func getMilesForCustomCells() {
        cells.enumerated().forEach { index, mileage in
            mileage.getMiles { result in
                self.cells[index].miles = result
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return defaultCells.count + cells.count
    }

    override func tableView(_: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.row < defaultCells.count {
            return []
        }
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { _, _ in
            let cell = self.cells[indexPath.row - self.defaultCells.count]
            self.distanceFao.delete(cell.id!, completion: {})
        }

//        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
//            // share item at indexPath
        ////            print("I want to share: \(self.tableArray[indexPath.row])")
//        }
//
//        edit.backgroundColor = .clear

        return [delete]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> (UITableViewCell) {
        if indexPath.row < defaultCells.count {
            let cellIdentifier = "MileageDefaultTableViewCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MileageDefaultTableViewCell else {
                fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
            }
            return defaultCells[indexPath.row].asTableViewCell(cell)
        } else {
            let cellIdentifier = "MileageTableViewCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MileageTableViewCell else {
                fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
            }
            let index = indexPath.row - defaultCells.count
            return cells[index].asTableViewCell(cell)
        }
    }
}
