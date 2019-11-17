//
//  MileageTableViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/2/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import CoreData
import Promises
import UIKit
class MileageTableViewController: UITableViewController {
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

    var cells: [NSManagedObject]! = [] {
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

        // This makes it so there are no extra empty cells displayed
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext

        // 2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Mileage")

        // 3
        do {
            cells = try managedContext.fetch(fetchRequest)
            getMilesForCustomCells()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func getMilesForCustomCells() {
        let mileageModels = cells.map { MileageModel($0) }
        mileageModels.enumerated().forEach { index, mileage in
            mileage.getMiles { result in
                self.cells[index].setValue(result, forKey: "miles")
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
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in

            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            let managedContext = appDelegate.persistentContainer.viewContext

            do {
                let cell = self.cells[indexPath.row - self.defaultCells.count]
                managedContext.delete(cell)
                self.cells.remove(at: indexPath.row - self.defaultCells.count)
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
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
            return MileageModel(cells[index]).asTableViewCell(cell)
        }
    }
}
