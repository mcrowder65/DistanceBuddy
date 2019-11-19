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
        let data = firebaseModel.toFirestore()
        ref = db.collection("distances").addDocument(data: data) { err in
            if let err = err {
                sendSentryEvent(message: err.localizedDescription, extra: data)
            } else {
                completion?(ref!.documentID)
            }
        }
    }

    func subscribe(_ complete: @escaping ([FirebaseModel]) -> Void) {
        let userId = "matt"
        db.collection("distances").whereField("userId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    if let err = error {
                        sendSentryEvent(message: err.localizedDescription, extra: ["userId": userId])
                    } else {
                        sendSentryEvent(message: "Somehow subscribing to distances, userId: \(userId) failed and the error was not defined")
                    }

                    return
                }
                let mileages = documents.map { MileageModel($0.data(), id: $0.documentID) }

                complete(mileages)
            }
    }

    func delete(_ id: String, completion: (() -> Void)? = nil) {
        db.collection("distances").document(id).delete { err in
            if let err = err {
                sendSentryEvent(message: err.localizedDescription, extra: ["id": id])
            } else {
                completion?()
            }
        }
    }

    func update(_ firebaseModel: FirebaseModel, id: String, completion: (() -> Void)? = nil) {
        let data = firebaseModel.toFirestore()
        db.collection("distances").document(id).setData(data) { err in
            if let err = err {
                sendSentryEvent(message: err.localizedDescription, extra: data)
            } else {
                completion?()
            }
        }
    }
}
