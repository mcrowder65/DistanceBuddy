//
//  HealthKitSetupAssistant.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 10/30/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import HealthKit

class HealthKitSetupAssistant {
  
  private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
  }
  
  class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
    guard HKHealthStore.isHealthDataAvailable() else {
      completion(false, HealthkitSetupError.notAvailableOnDevice)
      return
    }
    
    let workouts = HKSampleType.workoutType()
        
    let healthKitTypesToRead: Set<HKObjectType> = [workouts]
    HKHealthStore().requestAuthorization(toShare: nil,
                                         read: healthKitTypesToRead) { (success, error) in
      completion(success, error)
    }
  }
    
}
