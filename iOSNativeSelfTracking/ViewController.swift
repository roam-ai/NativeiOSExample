//
//  ViewController.swift
//  iOSNativeSelfTracking
//
//  Created by Adhamsheriff Ahamed Sheriff on 29/01/25.
//

import UIKit
import Roam

class ViewController: UIViewController {
    
    lazy var createUserButton: UIButton = {
        createButton(title: "Create User", action: #selector(createUser))
    }()
    lazy var startTrackingButton: UIButton = {
        createButton(title: "Start Tracking", action: #selector(startTracking))
    }()
    lazy var stopTrackingButton: UIButton = {
        createButton(title: "Stop Tracking", action: #selector(StopTracking))
    }()
    lazy var ConfigureBatch: UIButton = {
        createButton(title: "Batch Configuration", action: #selector(configureBatch))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(createUserButton)
        view.addSubview(startTrackingButton)
        view.addSubview(stopTrackingButton)
        view.addSubview(ConfigureBatch)
        NSLayoutConstraint.activate([
            createUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createUserButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            createUserButton.heightAnchor.constraint(equalToConstant: 50),
            createUserButton.widthAnchor.constraint(equalToConstant: 200),
                        
            startTrackingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startTrackingButton.topAnchor.constraint(equalTo: createUserButton.bottomAnchor, constant: 40),
            startTrackingButton.heightAnchor.constraint(equalTo: createUserButton.heightAnchor),
            startTrackingButton.widthAnchor.constraint(equalTo: createUserButton.widthAnchor),
            
            stopTrackingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopTrackingButton.topAnchor.constraint(equalTo: startTrackingButton.bottomAnchor, constant: 40),
            stopTrackingButton.heightAnchor.constraint(equalTo: startTrackingButton.heightAnchor),
            stopTrackingButton.widthAnchor.constraint(equalTo: startTrackingButton.widthAnchor),
            
            ConfigureBatch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ConfigureBatch.topAnchor.constraint(equalTo: stopTrackingButton.bottomAnchor, constant: 40),
            ConfigureBatch.heightAnchor.constraint(equalTo: stopTrackingButton.heightAnchor),
            ConfigureBatch.widthAnchor.constraint(equalTo: stopTrackingButton.widthAnchor),
        ])
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8.0
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc private func startTracking() {
        RoamSDKHandler.shared.startRoamTracking(mode: .active)
    }
    
    @objc private func StopTracking() {
        RoamSDKHandler.shared.stopTracking()
    }
 
    @objc private func createUser() {
        RoamSDKHandler.shared.createUser { userId in
            print("User ID: \(userId ?? "na")")
        }
    }
    
    @objc private func configureBatch() {
        // Set true to enable
        // Set false to disable
        UserDefaults.standard.set(true, forKey: "batchEnabled")
        // Batch Sync Interval
        UserDefaults.standard.set(1, forKey: "batchInput")
        
        RoamSDKHandler.shared.configureBatchSync()
    }
}
