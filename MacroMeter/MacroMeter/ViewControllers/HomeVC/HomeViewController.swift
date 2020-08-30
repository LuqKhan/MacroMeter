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
    var macroCalculator: MacroCalculator!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    func prepareUI() {
        
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
        self.menuDropDown.dataSource = ["Edit", "Notifications"]
        
        
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
            switch index {
            case 0:
                //4 meals
                
                let protein = Int(self.macroCalculator.macros[0])! / 4
                let macroProtein = String(protein)
                let carbs = Int(self.macroCalculator.macros[1])! / 4
                let macroCarb = String(carbs)
                let fat = Int(self.macroCalculator.macros[2])! / 4
                let macroFat = String(fat)
                let display = "Macro Breakdown Per Meal: \nProtein: \(macroProtein)g \nCarbs: \(macroCarb)g \nFat: \(macroFat)g"
                self.mealBreakdownLabel.text = display
            case 1:
                //3 meals
                let protein = Int(self.macroCalculator.macros[0])! / 3
                let macroProtein = String(protein)
                let carbs = Int(self.macroCalculator.macros[1])! / 3
                let macroCarb = String(carbs)
                let fat = Int(self.macroCalculator.macros[2])! / 3
                let macroFat = String(fat)
                let display = "Macro Breakdown Per Meal: \nProtein: \(macroProtein)g \nCarbs: \(macroCarb)g \nFat: \(macroFat)g"
                self.mealBreakdownLabel.text = display
            case 2:
                //3 meals and 2 snacks
                let protein = Int(self.macroCalculator.macros[0])! / 8
                let macroProtein = String(protein)
                let carbs = Int(self.macroCalculator.macros[1])! / 8
                let macroCarb = String(carbs)
                let fat = Int(self.macroCalculator.macros[2])! / 8
                let macroFat = String(fat)
                
                let mealProtein = protein * 2
                let mealCarbs = carbs * 2
                let mealFats = fat * 2
                
               let display = "For Snacks \nProtein: \(macroProtein)g, Carbs: \(macroCarb)g, Fats: \(macroFat)g\n For Meals: \n Protein: \(mealProtein)g, Carbs: \(mealCarbs)g, Fats: \(mealFats)g"
                self.mealBreakdownLabel.text = display
            default:
                break
            }
            
            
        }
    }
    @IBAction func menuTapped(_ sender: UIButton) {
        self.menuDropDown.show()
        self.menuDropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            if index == 0 {
                let editVC = GetStartedViewController()
                editVC.edit = true
                editVC.modalPresentationStyle = .overFullScreen
                self.present(editVC, animated: true, completion: nil)
                
            } else {
                let notificationsVC = NotificationsViewController()
                notificationsVC.modalPresentationStyle = .overFullScreen
                self.present(notificationsVC, animated: true, completion: nil)
                
            }
            
            
        }
    }
}
