//
//  RoamSDKHandler.swift
//  iOSNativeSelfTracking
//
//  Created by Dinesh Kumar A on 26/03/25.
//
import Roam

class RoamSDKHandler {
    
    // Singleton instance
    static let shared = RoamSDKHandler()
    private init() {}
    // Add your publish key
    private let publishKey = ""
    
    //MARK: - ROAM Methods
    func initalize() {
        Roam.delegate = self
        Roam.initialize(publishKey)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            Roam.requestLocation()
        }
    }
    
    func enableOfflineTracking() {
        Roam.offlineLocationTracking(true)
    }
    
    func requestLocation() {
        Roam.requestLocation()
    }
    
    func createUser(completion: ((String?) -> ())? = nil) {
        Roam.createUser("") { [weak self] user, error in
            if let userID = user?.userId {
                self?.toogleEventsAndListner() {}
                UserDefaults.standard.set(userID, forKey: "RoamUserID")
                completion?(userID)
            }else{
                if let error = error {
                    print("Error: \(error.message ?? "")")
                }
                completion?(nil)
            }
        }
    }
    
    func getUser(id: String) {
        Roam.getUser(id) { [weak self] user, error in
            if let error = error {
                print("Error: \(error.message ?? "")")
            }
            print("User: \(user?.userId ?? "na")")
            self?.toogleEventsAndListner() {}
        }
    }
    
    func toogleEventsAndListner(_ completion: @escaping () -> Void?) {
        Roam.toggleListener(Events: false, Locations: true) { roamUser, error in
            if let useriD = roamUser?.userId {
                Roam.subscribe(.Location, useriD) { status, userId, error in
                    print("Subscription status: \(status ?? "na")")
                    print("Subscription userId: \(userId ?? "na")")
                    print("Subscription error: \(error)")
                }
            }
            completion()
        }
    }
    
    func logout() {
        Roam.logoutUser { status, error in
            print("Logout status: \(status ?? "na")")
            Roam.initialize(self.publishKey)
        }
    }
    
    func startRoamTracking(mode: RoamTrackingMode, option: RoamTrackingCustomMethods? = nil) {
//        enableOfflineTracking()
        Roam.startTracking(mode, options: option) { tracking, error in
            if let error = error {
                print("Error: \(error.message ?? "")")
            }
            print("Roam tracking: \(tracking ?? "na")")}
    }
    
    func stopTracking(completion: (() ->())? = nil ) {
        Roam.stopTracking() { status, error in
            completion?()
        }
    }
}

//MARK: - RoamDelegate

extension RoamSDKHandler: RoamDelegate {
    func didUpdateLocation(_ locations: [RoamLocation]) {
        
        let latitude = locations[0].location.coordinate.latitude
        let longitude = locations[0].location.coordinate.longitude
        let speed = locations[0].speed
        let horizontalAccuracy = locations[0].location.horizontalAccuracy
        let verticalAccuracy = locations[0].location.verticalAccuracy
        let recordedAt = locations[0].recordedAt
        print("---->> latitude: \(latitude), longitude: \(longitude)")
        
    }
    
    func onError(_ error: RoamError) {
        //
    }
}
