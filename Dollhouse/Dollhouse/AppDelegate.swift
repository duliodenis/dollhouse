//
//  AppDelegate.swift
//  Dollhouse
//
//  Created by Dulio Denis on 4/11/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Power the app with Local Datastore
        Parse.enableLocalDatastore()
        // Initialize Parse.
        Parse.setApplicationId("YOUR_APP_ID",
            clientKey: "YOUR_CLIENT_ID")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)

        return true
    }

}

