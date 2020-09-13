//
//  MacroCalculator.swift
//  MacroMeter
//
//  Created by Luqmaan Khan on 8/29/20.
//  Copyright © 2020 Luqmaan Khan. All rights reserved.
//

import Foundation

class MacroCalculator {
    
    var height: String
    var age: String
    var weight: String
    var gender: String
    var exerciseFreq: String
    var goal: String
    var macros: [String]!
    var calories: Int!
    
    init(height: String, age: String, gender: String, weight: String, exerciseFreq: String, goal: String ) {
        self.height = height
        self.age = age
        self.weight = weight
        self.gender = gender
        self.exerciseFreq = exerciseFreq
        self.goal = goal
        
        self.calories = calculateCalories()
        calculateMacros()
    }
    
    func calculateHeight(height: String) -> Int {
        var totalInches: Int = 0
        
        if let inches = height.last, let feet = height.first {
            let feetString = String(feet)
            let inchesString = String(inches)
            
            if let unwrappedFeet = Int(feetString), let unwrappedInches = Int(inchesString) {
                let heightInches = unwrappedFeet * 12
                totalInches = heightInches + unwrappedInches
            }
        }
        return totalInches
    }
    
    func calculateBMR(height: String, weight: String, age: String, gender: String) -> Double {
           
           let totalInches = calculateHeight(height: height)
           
        let ageInt = Int(age)
        let weightInt = Int(weight)
        
           var bmr: Double = 0
           if gender == "Male" {
            let weightCalc = 6.23 * Double(weightInt!)
               let heightCalc = 12.7 * Double(totalInches)
            let ageCalc = 6.8 * Double(ageInt!)
               let mBmr = 66 + weightCalc + heightCalc - ageCalc
               bmr = mBmr
           } else {
            let weightCalc = 4.35 * Double(weightInt!)
               let heightCalc = 4.7 * Double(totalInches)
            let ageCalc = 4.5 * Double(ageInt!)
               let fBmr = 655 + weightCalc + heightCalc - ageCalc
               bmr = fBmr
           }
           return bmr
       }
    
    
    func calculateTDEE(daysPerWeekofExercise: String) -> Double {
        var tdee: Double
        let bmr = calculateBMR(height: self.height, weight: self.weight, age: self.age, gender: self.gender)
        switch daysPerWeekofExercise{
            case "0 days":
                tdee = bmr * 1.2
            case "1-2 days":
                tdee = bmr * 1.375
            case "3-4 days":
                tdee = bmr * 1.55
            case "5-6 days":
                tdee = bmr * 1.725
            default:
                tdee = bmr * 1.9
        }
        return tdee
    }
    
    func calculateCalories() -> Int {

        let tdee = calculateTDEE(daysPerWeekofExercise: self.exerciseFreq)
           var totalCalories: Int
        switch self.goal {
           case "aggressive weight loss":
               totalCalories = Int(tdee * 0.8)
           case "moderate weight loss":
               totalCalories = Int(tdee * 0.85)
           case "weight loss":
               totalCalories = Int(tdee * 0.9)
           case "maintain weight":
               totalCalories = Int(tdee)
           case "moderate weight gain":
               totalCalories = Int(tdee * 1.1)
           default:
               totalCalories = Int(tdee * 1.15)
               
           }
           return totalCalories
       }
    
    func calculateMacros()  {
           
           let totalCalories = calculateCalories()
           let gramsProtein = String(Int(Double(totalCalories) * (0.075)))
           let gramsCarbs = String(Int(Double(totalCalories) * (0.1)))
           let gramsFat = String(Int(Double(totalCalories) * (0.033)))
           
           let macros: [String] = [gramsProtein,gramsCarbs, gramsFat]
      
        self.macros = macros
        
           
       }
    
}
    
