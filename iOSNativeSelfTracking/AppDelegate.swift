//
//  AppDelegate.swift
//  iOSNativeSelfTracking
//

import UIKit
import Roam

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Add your publish key
        Roam.initialize("PUBLISH_KEY")
        Roam.requestLocation()
        Roam.delegate = self
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

extension AppDelegate: RoamDelegate {
    func didUpdateLocation(_ locations: [RoamLocation]) {
        
        let latitude = locations[0].location.coordinate.latitude
        let longitude = locations[0].location.coordinate.longitude
        let speed = locations[0].speed
        let horizontalAccuracy = locations[0].location.horizontalAccuracy
        let verticalAccuracy = locations[0].location.verticalAccuracy
        let recordedAt = locations[0].recordedAt
        
        
        print("---->> latitude: \(latitude), longitude: \(longitude)")
    }
}
