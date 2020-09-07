//
//  NotificationsViewController.swift
//  MacroMeter
//
//  Created by Luqmaan Khan on 8/29/20.
//  Copyright © 2020 Luqmaan Khan. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsViewController: UIViewController {
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBOutlet weak var doneButton: UIButton!
    
    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.doneButton.layer.cornerRadius = 10
        self.doneButton.layer.borderWidth = 1
        self.doneButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @objc func scheduleNotifications() {
        
    }
    
    
    @IBAction func notificationSwitched(_ sender: UISwitch) {
        if sender.isOn {
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    
                } else {
                    
                }
            }
        }
        
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
