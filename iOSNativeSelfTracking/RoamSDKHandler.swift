//
//  RoamSDKHandler.swift
//  iOSNativeSelfTracking
//
//  Created by Dinesh Kumar A on 26/03/25.
//

// Import the Roam SDK & RoamBatchConnector
import Roam
import RoamBatchConnector

class RoamSDKHandler {
    
    // Singleton instance
    static let shared = RoamSDKHandler()
    private init() {}
    
    // Roam publishable key (replace with your key)
    // Add your Roam publishable key here.  This is a crucial piece of information.  The `publishKey` is a unique identifier provided by Roam.ai that's required to initialize and authenticate your application with their service.
    //**Important:** You *publishable key* and *Bundle Id* should match as per configuration in the Dashboard.
    private let publishKey = ""
    
    //MARK: - ROAM Methods
    func initalize() {
        // Sets the delegate for the Roam SDK.  The delegate is an object that will receive events and updates from the Roam SDK, such as location changes or errors.
        Roam.delegate = self
        
        // Initializes the Roam SDK with the publish key.  This is the essential step to start using the Roam.ai service.
        Roam.initialize(publishKey)
        // All Roam methods must be called only after successful SDK initialization.
        // Calling them too early on Sequence (especially on first launch) can result in `MotionStatus.ERROR_INITIALIZE`.
        // This is a very important comment from the original code. It highlights a potential issue:  The Roam SDK might not be ready immediately after the `initialize` method is called.  The comment suggests a delay, especially on the first launch of the app.
        // Delay is not required if you are not calling in a sequence (eg: In a viewController)
        //This delay is likely a workaround to ensure the Roam SDK is fully initialized before attempting to use its methods.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            Roam.requestLocation()
        }
        
        // Checks if a Roam user ID is stored in UserDefaults.
        // If a user ID is found in UserDefaults, the `getUser` method is called to retrieve the user's information from the Roam
        if let userdId = UserDefaults.standard.value(forKey: "RoamUserID") as? String {
            getUser(id: userdId)
        }
        
        // Initialize Roam Batch Connector (for sync).
        initalizeBatchConnector()
        // Configure Batch Sync with preferences.
        configureBatchSync()
    }
    
    // Enables the Roam SDK to continue tracking location data even when the device is not connected to the internet.
    func enableOfflineTracking() {
        Roam.offlineLocationTracking(true)
    }
    
    // Manually request location permission.
    func requestLocation() {
        Roam.requestLocation()
    }
    
    /// Creates a new Roam user and saves the user ID in UserDefaults.
    func createUser(completion: ((String?) -> ())? = nil) {
        print(#function)
        // create user with description
        //"YOUR-USER-DESCRIPTION-GOES-HERE"
        Roam.createUser("") { [weak self] user, error in
            if let userID = user?.userId {
                // Save user ID for later use.
                UserDefaults.standard.set(userID, forKey: "RoamUserID")
                // Enable location listener and subscribe to events.
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
    
    /// Fetches user details for a given Roam user ID.
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
    
    /// Enables location listener and subscribes to location events.
    func toogleEventsAndListner(_ completion: @escaping () -> Void?) {
        Roam.toggleListener(Events: false, Locations: true) { roamUser, error in
            if let useriD = roamUser?.userId {
                // Subscribe to real-time location updates
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
    
    /// Logs out the current Roam user and reinitializes the SDK.
    func logout() {
        Roam.logoutUser { status, error in
            print("Logout status: \(status ?? "N/A")")
            // Reinitialize SDK after logout.
            Roam.initialize(self.publishKey)
        }
    }
    
    // Starts Roam tracking with the given mode and optional custom options.
    func startRoamTracking(mode: RoamTrackingMode, option: RoamTrackingCustomMethods? = nil) {
        // Enable offline tracking before starting.
        enableOfflineTracking()
        // Start location tracking.
        Roam.startTracking(mode, options: option) { tracking, error in
            if let error = error {
                print("Start Tracking Error: \(error.message ?? "Unknown error")")
            } else {
                print("Roam Tracking Started: \(tracking ?? "N/A")")
            }
        }
    }
    
    /// Stops Roam tracking.
    func stopTracking(completion: (() ->())? = nil ) {
        Roam.stopTracking() { status, error in
            completion?()
        }
    }
}

// MARK: - RoamDelegate Implementation
extension RoamSDKHandler: RoamDelegate {
    /// Called when a new location update is available.
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
    
    /// Called when any error is encountered by the Roam SDK.
    func onError(_ error: RoamError) {
        print("Roam Error - Code: \(error.code ?? "N/A"), Message: \(error.message ?? "Unknown error")")
    }
}

// MARK: - Roam Batch Connector Methods
extension RoamSDKHandler{
    /// Initializes the RoamBatch connector
    func initalizeBatchConnector() {
        RoamBatch.shared.initialize()
        RoamBatch.shared.enableLogging()
    }
    
    /// Configures batch sync preferences (such as interval and which data types to sync).
    func configureBatchSync() {
        let batchPublish = RoamBatchPublish()
        batchPublish.enableAll()  // Enable all Data Enrichment types for batch publish
        
        // Fetch user preferences from UserDefaults
        let batchEnabled = UserDefaults.standard.bool(forKey: "batchEnabled")
        let syncValue: NSNumber? = UserDefaults.standard.integer(forKey: "batchInput") as NSNumber
        let syncHour: NSNumber? = (syncValue != 0) ? syncValue : nil
        // Apply batch sync settings
        RoamBatch.shared.setConfig(enable: batchEnabled, syncHour: syncHour, publish: batchPublish)
    }
}

