//
//  AppDelegate.swift
//  Talabat
//
//  Created by 68lion on 3/17/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

let apiKy = "AIzaSyCRMeKXk63pTU8YC3Shpn8DHFW5Kl2Ze0Y"

let apiKy2 = "AIzaSyAe60T75FEu_LWmqMgyYwA8vxGWg4Iw-V8"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSPlacesClient.provideAPIKey(apiKy)
        GMSServices.provideAPIKey(apiKy)
        GMSPlacesClient.provideAPIKey(apiKy2)
        GMSServices.provideAPIKey(apiKy2)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

