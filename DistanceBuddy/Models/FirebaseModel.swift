//
//  FirebaseModel.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 11/18/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import Foundation

protocol FirebaseModel {
    init(_ fireStoreObject: [String: Any], id: String)
    func toFirestore() -> [String: Any]
}
