//
//  ViewController.swift
//  iOSNativeSelfTracking
//
//  Created by Adhamsheriff Ahamed Sheriff on 29/01/25.
//

import UIKit
import Roam

class ViewController: UIViewController {
  lazy var startTrackingButton: UIButton = {
    createButton(title: "Start Tracking", action: #selector(startTracking))
  }()
  lazy var stopTrackingButton: UIButton = {
    createButton(title: "Stop Tracking", action: #selector(StopTracking))
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(startTrackingButton)
    view.addSubview(stopTrackingButton)
    NSLayoutConstraint.activate([
      startTrackingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      startTrackingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
      startTrackingButton.heightAnchor.constraint(equalToConstant: 50),
      startTrackingButton.widthAnchor.constraint(equalToConstant: 200),
      stopTrackingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stopTrackingButton.topAnchor.constraint(equalTo: startTrackingButton.bottomAnchor, constant: 40),
      stopTrackingButton.heightAnchor.constraint(equalTo: startTrackingButton.heightAnchor),
      stopTrackingButton.widthAnchor.constraint(equalTo: startTrackingButton.widthAnchor),
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
    Roam.startTracking(.active) { status, error in
      print("tracking status: \(status)")
    }
  }
  @objc private func StopTracking() {
    Roam.stopTracking { status, error in
      print(status, error)
   }
  }
}
