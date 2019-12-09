//
//  AppDelegate.swift
//  DistanceBuddy
//
//  Created by Matt Crowder on 10/29/19.
//  Copyright © 2019 Matt. All rights reserved.
//

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import CoreData
import Firebase
import Sentry
import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func applicationDidFinishLaunching(_: UIApplication) {
        MSAppCenter.start("d4a29191-2643-4704-8473-b3a57e8d5850", withServices: [
            MSAnalytics.self,
            MSCrashes.self,
        ])
    }

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do {
            Client.shared = try Client(dsn: "https://be370b7ddd494723a158538d6cdd7c06@sentry.io/1826292")
            try Client.shared?.startCrashHandler()
        } catch {
            print("\(error)")
        }

        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_: UIApplication) {}
}
