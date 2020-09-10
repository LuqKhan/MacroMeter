//
//  HomeViewController.swift
//  MacroMeter
//
//  Created by Luqmaan Khan on 8/29/20.
//  Copyright © 2020 Luqmaan Khan. All rights reserved.
//

import UIKit
import DropDown
import VisionKit
import Vision
import PieCharts


class HomeViewController: UIViewController, NutritionDataDelegate {
    
    
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var caloriesBlue: UIView!
    @IBOutlet weak var dailyProteinLabel: UILabel!
    @IBOutlet weak var carbRed: UIView!
    @IBOutlet weak var proteinGreen: UIView!
    @IBOutlet weak var pieChart: PieChart!
    @IBOutlet weak var dailyCarbsLabel: UILabel!
    
    @IBOutlet weak var dailyFatLabel: UILabel!
    @IBOutlet weak var yelloFat: UIView!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var dailyCaloriesLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    
    @IBOutlet weak var carbsLabel: UILabel!
    
    @IBOutlet weak var fatLabel: UILabel!
     
   
    
    let menuDropDown = DropDown()
    let mealFrequencyDropDown = DropDown()
    var macroCalculator: MacroCalculator!
    
    var fatsConsumed: Double?
    var proteinConsumed: Double?
    var caloriesConsumed: Double?
    var carbsConsumed: Double?
   
    let scannerVC = NutritionLabelScannerViewController()
    let date = Date()
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        scannerVC.delegate = self
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        dateFormatter.dateFormat  = "EEEE"
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        let dayInWeek = dayDateFormatter.string(from: date)
        
        self.dateLabel.text = "\(nameOfMonth), \(dayInWeek) \(day) \(year)"
        
        if calendar.isDateInYesterday(date) {
            UserDefaults.standard.set(0, forKey: "fatPerServing")
            UserDefaults.standard.set(0, forKey: "proteinPerServing")
            UserDefaults.standard.set(0, forKey: "carbsPerServing")
             UserDefaults.standard.set(0, forKey: "caloriesPerServing")
            
        }
    
        
        
        let totalFat = UserDefaults.standard.double(forKey: "fatPerServing")
        let totalProtein = UserDefaults.standard.double(forKey: "proteinPerServing")
        let totalCarbs = UserDefaults.standard.double(forKey: "carbsPerServing")
        let totalCalories = UserDefaults.standard.double(forKey: "caloriesPerServing")
        
        self.dailyCaloriesLabel.text = "Calories: \(totalCalories.rounded(toPlaces: 1))"
               self.dailyFatLabel.text = "Fat: \(totalFat.rounded(toPlaces: 1))g"
               self.dailyCarbsLabel.text = "Carbohydrate: \(totalCarbs.rounded(toPlaces: 1))g"
               self.dailyProteinLabel.text = "Protein: \(totalProtein.rounded(toPlaces: 1))g"
               self.pieChart.models.removeAll()
               self.pieChart.models = [PieSliceModel(value: totalFat, color: .yellow), PieSliceModel(value: totalCalories, color: .blue), PieSliceModel(value: totalProtein, color: .green), PieSliceModel(value: totalCarbs, color: .red)]
        
        
        
        self.fatsConsumed = totalFat
        self.proteinConsumed = totalProtein
        self.carbsConsumed = totalCarbs
        self.caloriesConsumed = totalCalories
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
    }
    
    @objc func tapped(UITapGestureRecognizer: UITapGestureRecognizer) {
        self.menuDropDown.hide()
    }
    
   
    func retrieveNutritionData(fat: Double, protein: Double, carbs: Double, cals: Double) {
        
        if calendar.isDateInYesterday(date) {
                   UserDefaults.standard.set(0, forKey: "fatPerServing")
                   UserDefaults.standard.set(0, forKey: "proteinPerServing")
                   UserDefaults.standard.set(0, forKey: "carbsPerServing")
                    UserDefaults.standard.set(0, forKey: "caloriesPerServing")
                   
               }
        
        
               var totalProtein = UserDefaults.standard.double(forKey: "proteinPerServing")
                   totalProtein = totalProtein + protein
                   var totalCarbs = UserDefaults.standard.double(forKey: "carbsPerServing")
                   totalCarbs = totalCarbs + carbs
                   var totalFat = UserDefaults.standard.double(forKey: "fatPerServing")
                   totalFat = totalFat + fat
                   var totalCalories = UserDefaults.standard.double(forKey: "caloriesPerServing")
                   totalCalories = totalCalories + cals
                   
                   UserDefaults.standard.set(totalProtein, forKey: "proteinPerServing")
                   UserDefaults.standard.set(totalFat, forKey: "fatPerServing")
                   UserDefaults.standard.set(totalCarbs, forKey: "carbsPerServing")
                   UserDefaults.standard.set(totalCalories, forKey: "caloriesPerServing")
        
        //when the day is over make sure to reset, use notification observer?
        
        self.dailyCaloriesLabel.text = "Calories: \(totalCalories.rounded(toPlaces: 1))"
        self.dailyFatLabel.text = "Fat: \(totalFat.rounded(toPlaces: 1))g"
        self.dailyCarbsLabel.text = "Carbohydrate: \(totalCarbs.rounded(toPlaces: 1))g"
        self.dailyProteinLabel.text = "Protein: \(totalProtein.rounded(toPlaces: 1))g"
        self.pieChart.models.removeAll()
        self.pieChart.models = [PieSliceModel(value: totalFat, color: .yellow), PieSliceModel(value: totalCalories, color: .blue), PieSliceModel(value: totalProtein, color: .green), PieSliceModel(value: totalCarbs, color: .red)]
        
       }
    
    func prepareUI() {
        

        self.proteinGreen.layer.cornerRadius = 3
        self.carbRed.layer.cornerRadius = 3
        self.caloriesBlue.layer.cornerRadius = 3
        self.yelloFat.layer.cornerRadius = 3
        
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
        
        menuDropDown.dismissMode = .automatic
        menuDropDown.textColor = .white
        menuDropDown.backgroundColor = .black
        menuDropDown.direction = .bottom
        menuDropDown.selectionBackgroundColor = .black
        
        self.menuDropDown.anchorView = self.menuButton
        self.menuDropDown.dataSource = ["Edit", "Meal Breakdown", "Log Macros"]
        
        self.menuButton.layer.cornerRadius = 10
        self.menuButton.layer.borderWidth = 1
        self.menuButton.layer.borderColor = UIColor.white.cgColor
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
                let breakdownVC = MealBreakdownViewController()
                breakdownVC.macroCalculator = self.macroCalculator
                breakdownVC.modalPresentationStyle = .overFullScreen
                self.present(breakdownVC, animated: true, completion: nil)
            } else {
                
                self.scannerVC.modalPresentationStyle = .overFullScreen
                self.present(self.scannerVC, animated: true, completion: nil)
            }
            
        }
    }
}
