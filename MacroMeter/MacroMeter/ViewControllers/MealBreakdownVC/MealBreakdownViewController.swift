//
//  MealBreakdownViewController.swift
//  MacroMeter
//
//  Created by Luqmaan Khan on 8/30/20.
//  Copyright © 2020 Luqmaan Khan. All rights reserved.
//

import UIKit
import PieCharts
import DropDown

class MealBreakdownViewController: UIViewController {
    @IBOutlet weak var protein: UIView!
    @IBOutlet weak var carbsLabel: UILabel!
    
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carb: UIView!
    @IBOutlet weak var fat: UIView!
    @IBOutlet weak var pieChart: PieChart!
    
    var macroCalculator: MacroCalculator!
    
    @IBOutlet weak var mealFrequencyButton: UIButton!
    
    let mealFrequencyDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideLabels()
        self.fat.layer.cornerRadius = 3
        self.protein.layer.cornerRadius = 3
        self.carb.layer.cornerRadius = 3
        
        mealFrequencyDropDown.textColor = .white
        mealFrequencyDropDown.backgroundColor = .black
        mealFrequencyDropDown.direction = .bottom
        mealFrequencyDropDown.selectionBackgroundColor = .black
        
        self.mealFrequencyDropDown.anchorView = self.mealFrequencyButton
        self.mealFrequencyDropDown.dataSource = ["4 meals", "3 meals", "3 meals and 2 snacks"]
        self.mealFrequencyButton.layer.cornerRadius = 10
        self.mealFrequencyButton.layer.borderWidth = 1
        self.mealFrequencyButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func showLabels() {
        self.protein.alpha = 1
        self.carb.alpha = 1
        self.fat.alpha = 1
        self.proteinLabel.alpha = 1
        self.carbsLabel.alpha = 1
        self.fatLabel.alpha = 1
        
    }
    private func hideLabels() {
        self.protein.alpha = 0
        self.carb.alpha = 0
        self.fat.alpha = 0
        self.proteinLabel.alpha = 0
        self.carbsLabel.alpha = 0
        self.fatLabel.alpha = 0
    }
    
    @IBAction func mealFreqTapped(_ sender: UIButton) {
        self.mealFrequencyDropDown.show()
        self.mealFrequencyDropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            switch index {
            case 0:
                //4 meals
                
                let protein = Double(self.macroCalculator.macros[0])! / 4
                
                let carbs = Double(self.macroCalculator.macros[1])! / 4
                
                let fat = Double(self.macroCalculator.macros[2])! / 4
                
                let intFat = Int(fat)
                let intCarb = Int(carbs)
                let intProtein = Int(protein)
                
                self.fatLabel.text = "Fat: \(intFat)g"
                self.carbsLabel.text = "Carbohydrates: \(intCarb)g"
                self.proteinLabel.text = "Protein: \(intProtein)g"
                self.showLabels()
                self.pieChart.models.removeAll()
                self.pieChart.models = [PieSliceModel(value: fat, color: .yellow), PieSliceModel(value: carbs, color: .red), PieSliceModel(value: protein, color: .green)]
                
            case 1:
            
                let protein = Double(self.macroCalculator.macros[0])! / 3
                let carbs = Double(self.macroCalculator.macros[1])! / 3
                
                let fat = Double(self.macroCalculator.macros[2])! / 3
    
                let intFat = Int(fat)
                let intCarb = Int(carbs)
                let intProtein = Int(protein)
                self.fatLabel.text = "Fat: \(intFat)g"
                self.carbsLabel.text = "Carbohydrates: \(intCarb)g"
                self.proteinLabel.text = "Protein: \(intProtein)g"
                self.showLabels()
                self.pieChart.models.removeAll()
                self.pieChart.models = [PieSliceModel(value: fat, color: .yellow), PieSliceModel(value: carbs, color: .red), PieSliceModel(value: protein, color: .green)]
                
            case 2:
                //3 meals and 2 snacks
                let protein = Double(self.macroCalculator.macros[0])! / 8
                //let macroProtein = String(protein)
                let carbs = Double(self.macroCalculator.macros[1])! / 8
                //let macroCarb = String(carbs)
                let fat = Double(self.macroCalculator.macros[2])! / 8
                //let macroFat = String(fat)
                let intFat = Int(fat)
                let intCarb = Int(carbs)
                let intProtein = Int(protein)
                self.fatLabel.text = "Fat: \(intFat)g"
                self.carbsLabel.text = "Carbohydrates: \(intCarb)g"
                self.proteinLabel.text = "Protein: \(intProtein)g"
                self.showLabels()
                self.pieChart.models.removeAll()
                self.pieChart.models = [PieSliceModel(value: fat, color: .yellow), PieSliceModel(value: carbs, color: .red), PieSliceModel(value: protein, color: .green)]
                
            default:
                break
            }
            
            
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
