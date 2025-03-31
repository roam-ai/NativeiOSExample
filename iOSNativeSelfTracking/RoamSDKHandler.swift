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
    
    private let publishKey = "" // Add your Roam publishable key here
    
    //MARK: - ROAM Methods
    func initalize() {
        Roam.delegate = self
        Roam.initialize(publishKey)
        // All Roam methods must be called only after successful SDK initialization.
        // Calling them too early on Sequence (especially on first launch) can result in `MotionStatus.ERROR_INITIALIZE`.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            Roam.requestLocation()
        }
        
        if let userdId = UserDefaults.standard.value(forKey: "RoamUserID") as? String {
            getUser(id: userdId)
        }
    }
    
    func enableOfflineTracking() {
        Roam.offlineLocationTracking(true)
    }
    
    func requestLocation() {
        Roam.requestLocation()
    }
    
    func createUser(completion: ((String?) -> ())? = nil) {
        print(#function)
        Roam.createUser("") { [weak self] user, error in
            if let userID = user?.userId {
                UserDefaults.standard.set(userID, forKey: "RoamUserID")
                self?.toogleEventsAndListner() {}
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
        print(#function)
        Roam.getUser(id) { user, error in
            if let error = error {
                print("Error: \(error.message ?? "Unknown error")")
            }else {
                print("User ID: \(user?.userId ?? "N/A")")
            }
        }
    }
    
    func toogleEventsAndListner(_ completion: @escaping () -> Void?) {
        Roam.toggleListener(Events: false, Locations: true) { roamUser, error in
            if let useriD = roamUser?.userId {
                Roam.subscribe(.Location, useriD) { status, subscribedUserId, error in
                    if let error = error {
                        print("Subscription error: \(error)")
                    }else {
                        print("Subscription status: \(status ?? "N/A")")
                        print("Subscribed userId: \(subscribedUserId ?? "N/A")")
                    }
                }
            }
            completion()
        }
    }
    
    func logout() {
        Roam.logoutUser { status, error in
            print("Logout status: \(status ?? "N/A")")
            //reinitializeSDK
            Roam.initialize(self.publishKey)
        }
    }
    
    func startRoamTracking(mode: RoamTrackingMode, option: RoamTrackingCustomMethods? = nil) {
        enableOfflineTracking()
        Roam.startTracking(mode, options: option) { tracking, error in
            if let error = error {
                print("Start Tracking Error: \(error.message ?? "Unknown error")")
            } else {
                print("Roam Tracking Started: \(tracking ?? "N/A")")
            }
        }
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
        guard let latestLocation = locations.first else { return }
        
        let coordinate = latestLocation.location.coordinate
        let speed = latestLocation.speed
        let hAccuracy = latestLocation.location.horizontalAccuracy
        let vAccuracy = latestLocation.location.verticalAccuracy
        let recordedAt = latestLocation.recordedAt ?? "N/A"
        
        print("""
                Location Updated ->
                Latitude: \(coordinate.latitude)
                Longitude: \(coordinate.longitude)
                Speed: \(speed)
                Horizontal Accuracy: \(hAccuracy)
                Vertical Accuracy: \(vAccuracy)
                Recorded At: \(recordedAt)
                """)
    }
    
    func onError(_ error: RoamError) {
        print("Roam Error - Code: \(error.code ?? "N/A"), Message: \(error.message ?? "Unknown error")")
    }
}
