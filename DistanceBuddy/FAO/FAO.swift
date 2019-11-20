//
//  FAO.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/18/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore
import Foundation
protocol FAO {
    func subscribe(_ complete: @escaping (FirebaseModel, DocumentChangeType) -> Void)
    func add(_ firebaseModel: FirebaseModel, completion: ((String) -> Void)?)
    func delete(_ id: String, completion: (() -> Void)?)
    func update(_ firebaseModel: FirebaseModel, id: String, completion: (() -> Void)?)
}
