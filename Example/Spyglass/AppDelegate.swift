//
//  AppDelegate.swift
//  Spyglass
//
//  Created by Alexsander Akers on 09/02/2016.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

import Spyglass
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let spyglass = Spyglass()

    // MARK: - App Delegte

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.delegate = spyglass
        }

        return true
    }
}
