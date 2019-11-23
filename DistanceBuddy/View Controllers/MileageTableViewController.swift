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

    @objc private func refresh(_: Any) {
        getMilesForDefaultCells {
            self.getMilesForCustomCells {
                self.refreshControl?.endRefreshing()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        getMilesForDefaultCells(nil)
        distanceFao.subscribe { mileageModel, type in
            let mileage = mileageModel as! MileageModel
            if type == .added {
                mileage.getMiles { result in
                    mileage.miles = result
                    self.cells.append(mileage)
                    self.tableView.reloadData()
                }
            }
            if type == .modified {
                let originalMileage = self.cells.first { $0.id == mileage.id }
                if originalMileage?.containsMileageChange(otherModel: mileage) ?? false {
                    mileage.getMiles { result in
                        mileage.miles = result
                        let cells: [MileageModel] = self.cells.enumerated().map { _, model in
                            if model.id == mileage.id {
                                return mileage
                            }
                            return model
                        }
                        self.cells = cells
                        self.tableView.reloadData()
                    }
                } else {
                    let cells: [MileageModel] = self.cells.enumerated().map { _, model in
                        if model.id == mileage.id {
                            mileage.miles = originalMileage?.miles
                            return mileage
                        }
                        return model
                    }
                    self.cells = cells
                    self.tableView.reloadData()
                }
            }

            if type == .removed {
                let cells: [MileageModel] = self.cells.filter { $0.id != mileage.id }
                self.cells = cells
                self.tableView.reloadData()
            }
        }
        // This makes it so there are no extra empty cells displayed
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func getMilesForDefaultCells(_ complete: (() -> Void)?) {
        authorizeHealthKit { _, _ in
            getWorkouts(completion: { (running: DefaultCellModel, walking: DefaultCellModel, cycling: DefaultCellModel) in
                DispatchQueue.main.async {
                    self.running = running
                    self.walking = walking
                    self.cycling = cycling
                    complete?()
                }
            })
        }
    }

    func getMilesForCustomCells(_ complete: (() -> Void)?) {
        all(cells.enumerated().map { index, mileage in
            Promise<String> { fulfill, _ in
                mileage.getMiles { result in
                    self.cells[index].miles = result
                    self.tableView.reloadData()
                    fulfill(result)
                }
            }
        }).then { _ in
            complete?()
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
            let alert = UIAlertController(title: "Are you you want to delete \(cell.title)", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes", style: .default, handler: { _ in
                self.distanceFao.delete(cell.id!, completion: nil)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)

            alert.addAction(cancel)
            alert.addAction(ok)

            self.present(alert, animated: true, completion: nil)
        }

        let edit = UITableViewRowAction(style: .default, title: "Edit") { _, indexPath in
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DistanceVC") as? UINavigationController
            let cell = self.cells[indexPath.row - self.defaultCells.count]
            (vc?.viewControllers[0] as? DistanceViewController)?.title = "Edit Distance"
            self.present(vc!, animated: false, completion: {
                (vc?.viewControllers[0] as? DistanceViewController)?.updateValues(from: cell)
            })
        }

        edit.backgroundColor = .clear

        return [delete, edit]
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
