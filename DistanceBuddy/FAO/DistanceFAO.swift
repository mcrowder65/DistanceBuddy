//
//  DistanceFAO.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/18/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

class DistanceFAO: FAO {
    lazy var db: Firestore! = {
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        return Firestore.firestore()
    }()

    func add(_ firebaseModel: FirebaseModel, completion: ((String) -> Void)?) {
        var ref: DocumentReference?
        ref = db.collection("distances").addDocument(data: firebaseModel.toFirestore()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                completion?(ref!.documentID)
            }
        }
    }

    func subscribe(_ complete: @escaping ([FirebaseModel]) -> Void) {
        db.collection("distances").whereField("userId", isEqualTo: "matt")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let mileages = documents.map { MileageModel($0.data(), id: $0.documentID) }

                complete(mileages)
            }
    }

    func delete(_ id: String, completion: (() -> Void)? = nil) {
        db.collection("distances").document(id).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                completion?()
            }
        }
    }

    func update(_ firebaseModel: FirebaseModel, id: String, completion: (() -> Void)? = nil) {
        db.collection("distances").document(id).setData(firebaseModel.toFirestore()) { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                completion?()
            }
        }
    }
}
