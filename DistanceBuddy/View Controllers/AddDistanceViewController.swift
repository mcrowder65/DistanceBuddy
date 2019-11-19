//
//  AddDistanceViewController.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/3/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore
import SwiftyPickerPopover
import UIKit
class AddDistanceViewController: UIViewController, UITextFieldDelegate {
    let distanceFao: DistanceFAO = DistanceFAO()
    var table: WorkoutTypeTableViewController?
    @IBOutlet var startDate: UITextField!
    @IBOutlet var endDate: UITextField!
    @IBOutlet var descriptionField: UITextField!

    @IBAction func save(_: Any) {
        let found = table?.cells.first(where: { $0.status == true })
        if found == nil {
            let alert = UIAlertController(title: "A workout type is required", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if !(descriptionField?.text?.isEmpty ?? false) {
            let descriptionValue = descriptionField?.text ?? ""
            let workoutTypes = table?.cells.filter { (WorkoutTypeModel) -> Bool in
                WorkoutTypeModel.status == true
            } ?? []
            let mileage = MileageModel(
                title: descriptionValue,
                workoutTypes: workoutTypes,
                startDate: textToDate(startDate.text),
                endDate: (endDate.text != "") ? textToDate(endDate.text) : nil
            )
            distanceFao.add(mileage, completion: { _ in
                self.dismiss(animated: true, completion: nil)
            })

        } else {
            let alert = UIAlertController(title: "Description is required", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func startDateClicked() {
        DatePickerPopover(title: "Start Date")
            .setDateMode(.date)
            .setSelectedDate(textToDate(startDate?.text))
            .setDoneButton(action: { _, selectedDate in
                self.startDate.text = dateToText(selectedDate)
                let date = textToDate(self.startDate.text)
                let endDate = textToDate(self.endDate.text)
                if date.isAfterDate(endDate, granularity: .day) {
                    self.endDate.text = ""
                }
            })
            .setCancelButton(action: { _, _ in print("cancel") })
            .appear(originView: startDate, baseViewController: self)
    }

    @IBAction func endDateClicked() {
        DatePickerPopover(title: "End Date")
            .setDateMode(.date)
            .setSelectedDate(textToDate(endDate?.text))
            .setDoneButton(action: { _, selectedDate in
                self.endDate.text = dateToText(selectedDate)
            })
            .setClearButton(title: "Clear", action: { popover, _ in
                self.endDate.text = ""
                popover.disappear()
            })
            .setMinimumDate(textToDate(startDate?.text))
            .setCancelButton(action: { _, _ in print("cancel") })
            .appear(originView: endDate, baseViewController: self)
    }

    // When pressing the return button, it dismisses the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        startDate.text = dateToText(Date())
        endDate.text = ""
        descriptionField.text = ""
        descriptionField.delegate = self

        // When tapping outside the keyboard, it will dismiss it
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "workoutTypes" {
            let vc: WorkoutTypeTableViewController = (segue.destination as? WorkoutTypeTableViewController)!
            table = vc
        }
    }
}
