//
//  DistanceFAO.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/18/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import Firebase
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

    func subscribe(_ complete: @escaping (FirebaseModel, DocumentChangeType) -> Void) -> ListenerRegistration {
        let user = Auth.auth().currentUser

        return db.collection("distances").whereField("userId", isEqualTo: user?.uid ?? "")
            .addSnapshotListener { querySnapshot, _ in
                querySnapshot?.documentChanges.forEach { diff in
                    let data = diff.document.data()
                    let mileage = MileageModel(data, id: diff.document.documentID)
                    complete(mileage, diff.type)
                }
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
