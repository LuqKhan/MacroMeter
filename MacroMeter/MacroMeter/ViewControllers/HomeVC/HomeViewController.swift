//
//  HomeViewController.swift
//  MacroMeter
//
//  Created by Luqmaan Khan on 8/29/20.
//  Copyright © 2020 Luqmaan Khan. All rights reserved.
//

import UIKit
import DropDown

class HomeViewController: UIViewController {

    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var mealFrequencyButton: UIButton!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
   
    @IBOutlet weak var carbsLabel: UILabel!
    
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var mealBreakdownLabel: UILabel!
    
    let menuDropDown = DropDown()
    let mealFrequencyDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       prepareUI()
    }
    
    func prepareUI() {
        mealFrequencyDropDown.textColor = .white
        mealFrequencyDropDown.backgroundColor = .black
        mealFrequencyDropDown.direction = .bottom
        mealFrequencyDropDown.selectionBackgroundColor = .black
        self.mealFrequencyDropDown.anchorView = self.mealFrequencyButton
        mealFrequencyDropDown.dataSource = ["4 meals a day", "3 meals a day", "3 meals and 2 snacks a day"]
        
        
        menuDropDown.textColor = .white
        menuDropDown.backgroundColor = .black
        menuDropDown.direction = .bottom
        menuDropDown.selectionBackgroundColor = .black
        
        self.menuDropDown.anchorView = self.menuButton
        self.menuDropDown.dataSource = ["Edit Weight/Goal", "Notifications"]
        
        
        self.logoImage.layer.cornerRadius = 10
        self.menuButton.layer.cornerRadius = 10
        self.menuButton.layer.borderWidth = 1
        self.menuButton.layer.borderColor = UIColor.white.cgColor
        self.mealFrequencyButton.layer.cornerRadius = 10
        self.mealFrequencyButton.layer.borderWidth = 1
        self.mealFrequencyButton.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func mealFreqTapped(_ sender: UIButton) {
        self.mealFrequencyDropDown.show()
        self.mealFrequencyDropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            
            
            
        }
    }
    @IBAction func menuTapped(_ sender: UIButton) {
        self.menuDropDown.show()
        self.menuDropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            if index == 0 {
                
            } else {
                let notificationsVC = NotificationsViewController()
                notificationsVC.modalPresentationStyle = .overFullScreen
                self.present(notificationsVC, animated: true, completion: nil)
                
            }
                 
                 
     }
    }
}
