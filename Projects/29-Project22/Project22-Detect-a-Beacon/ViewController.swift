//
//  ViewController.swift
//  Project22-Detect-a-Beacon
//
//  Created by deathlezz on 04/10/2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var beaconDetected = true
    
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var circleView: UIView!
    
    var currentUUID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        view.backgroundColor = .gray
        
        nameLabel.text = "NO BEACON FOUND"
        
        // Challenge 3
        circleView.layer.cornerRadius = 128
        circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                // do stuff
                startScanning()
            }
        }
    }
    
    func startScanning() {
        addBeacon(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456)
        addBeacon(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456)
        addBeacon(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456)
    }
    
    func addBeacon(uuidString: String, major: Int, minor: Int) {
        let uuid = UUID(uuidString: uuidString)!
        let constraint = CLBeaconIdentityConstraint(uuid: uuid)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: uuid.uuidString)
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: constraint)
    }
    
    func update(distance: CLProximity, name: String) {
        UIView.animate(withDuration: 1) { [weak self] in
            
            self?.nameLabel.text = "\(name)"
            
            switch distance {
            case .immediate:
                self?.view.backgroundColor = .red
                self?.distanceReading.text = "RIGHT HERE"
                self?.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
            case .near:
                self?.view.backgroundColor = .orange
                self?.distanceReading.text = "NEAR"
                self?.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .far:
                self?.view.backgroundColor = .blue
                self?.distanceReading.text = "FAR"
                self?.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            default:
                self?.view.backgroundColor = .gray
                self?.distanceReading.text = "UNKNOWN"
                self?.nameLabel.text = "NO BEACON FOUND"
                self?.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
    
    // Challenge 1
    func showAlert() {
        if beaconDetected {
            beaconDetected = false
            let ac = UIAlertController(title: "Beacon detected", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            
            // Challenge 2
            if currentUUID == nil {
                currentUUID = region.uuid
            }
            guard currentUUID == region.uuid else { return }
            update(distance: beacon.proximity, name: region.identifier)
            
            // Challenge 1
            showAlert()
        } else {
            // Challenge 2
            guard currentUUID == region.uuid else { return }
            currentUUID = nil
            update(distance: .unknown, name: "NO BEACON FOUND")
        }
    }
}

