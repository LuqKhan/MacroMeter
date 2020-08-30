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
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    
    @IBOutlet weak var carbsLabel: UILabel!
    
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var mealBreakdownLabel: UILabel!
    
    let menuDropDown = DropDown()
    let mealFrequencyDropDown = DropDown()
    var macroCalculator: MacroCalculator!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    func prepareUI() {
        
        if let gender = UserDefaults.standard.object(forKey: "gender") as? String,
            let age = UserDefaults.standard.object(forKey: "age") as? String ,
            let weight = UserDefaults.standard.object(forKey: "weight") as? String ,
            let height = UserDefaults.standard.object(forKey: "height") as? String ,
            let goal = UserDefaults.standard.object(forKey: "goal") as? String ,
            let freq = UserDefaults.standard.object(forKey: "exerciseFreq") as? String {
            
            let macroCalc = MacroCalculator(height: height, age: age, gender: gender, weight: weight, exerciseFreq: freq, goal: goal)
            self.macroCalculator = macroCalc
        }
            self.caloriesLabel.text = String(macroCalculator.calories)
                  self.carbsLabel.text = "\(self.macroCalculator.macros[1])g"
                  self.proteinLabel.text = "\(self.macroCalculator.macros[0])g"
                  self.fatLabel.text = "\(self.macroCalculator.macros[2])g"
            
        
        
        
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
        self.menuDropDown.dataSource = ["Edit", "Notifications", "Meal Breakdown"]
        
        
        self.logoImage.layer.cornerRadius = 10
        self.menuButton.layer.cornerRadius = 10
        self.menuButton.layer.borderWidth = 1
        self.menuButton.layer.borderColor = UIColor.white.cgColor
        self.mealFrequencyButton.layer.cornerRadius = 10
        self.mealFrequencyButton.layer.borderWidth = 1
        self.mealFrequencyButton.layer.borderColor = UIColor.white.cgColor
    }
    @IBAction func menuTapped(_ sender: UIButton) {
        self.menuDropDown.show()
        self.menuDropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            if index == 0 {
                let editVC = GetStartedViewController()
                editVC.edit = true
                editVC.modalPresentationStyle = .overFullScreen
                self.present(editVC, animated: true, completion: nil)
                
            } else if index == 1 {
                let notificationsVC = NotificationsViewController()
                notificationsVC.modalPresentationStyle = .overFullScreen
                self.present(notificationsVC, animated: true, completion: nil)
                
            } else {
                let breakdownVC = MealBreakdownViewController()
                breakdownVC.modalPresentationStyle = .overFullScreen
                self.present(breakdownVC, animated: true, completion: nil)
            }
            
            
        }
    }
}
