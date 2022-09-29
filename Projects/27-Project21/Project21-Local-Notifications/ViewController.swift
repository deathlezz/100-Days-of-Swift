//
//  ViewController.swift
//  Project21-Local-Notifications
//
//  Created by deathlezz on 28/09/2022.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(runSchedule))
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("yay")
            } else {
                print("D'oh!")
            }
        }
    }
    
    // Challenge 2
    @objc func runSchedule() {
        scheduleLocal(delay: 5)
    }
    
    @objc func scheduleLocal(delay seconds: TimeInterval) {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the sedond mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzBuzz"]
        content.sound = .default
        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "Show", title: "Tell me more", options: .foreground)
        let share = UNNotificationAction(identifier: "Share", title: "Share", options: .foreground)
        // Challenge 2
        let delay = UNNotificationAction(identifier: "Delay", title: "Remind me later", options: .authenticationRequired)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, share, delay], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
            case "Show":
                print("Show more information...")
                
                // Challenge 1
                let ac = UIAlertController(title: "Info", message: "User tapped \"Tell me more\" button", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            case "Share":
                print("Sharing the alert...")
                let ac = UIAlertController(title: "Share", message: "User tapped \"Share\" button", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            // Challenge 2
            case "Delay":
                print("User will be reminded later...")
                scheduleLocal(delay: 86400)
            default:
                break
            }
        }
        
        completionHandler()
    }
    
}

