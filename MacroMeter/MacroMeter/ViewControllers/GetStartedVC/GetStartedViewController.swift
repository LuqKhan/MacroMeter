//
//  GetStartedViewController.swift
//  MacroMeter
//
//  Created by Luqmaan Khan on 8/29/20.
//  Copyright © 2020 Luqmaan Khan. All rights reserved.
//

import UIKit
import DropDown

class GetStartedViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var getStarted: UILabel!
    var edit: Bool = false
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var weightlossGoalButton: UIButton!
    @IBOutlet weak var exerciseFrequencyButton: UIButton!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    let weightLossGoalsDropDown = DropDown()
    let exerciseFrequencyDropDown = DropDown()
    var maleSelected = false
    var femaleSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.edit {
            self.getStarted.text = "Edit"
        }
       prepareUI()
    }
    
    func prepareUI() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(UITapGesture:)))
              self.view.addGestureRecognizer(tapGesture)
    //do the same drop down for exercise frequency
        exerciseFrequencyDropDown.textColor = .white
        exerciseFrequencyDropDown.backgroundColor = .black
        exerciseFrequencyDropDown.direction = .bottom
        exerciseFrequencyDropDown.selectionBackgroundColor = .black
        exerciseFrequencyDropDown.anchorView = self.exerciseFrequencyButton
        exerciseFrequencyDropDown.dataSource = ["0 days", "1-2 days", "3-4 days", "5-6 days", "7 days"]
        
        
        weightLossGoalsDropDown.textColor = .white
        weightLossGoalsDropDown.backgroundColor = .black
        weightLossGoalsDropDown.direction = .bottom
        weightLossGoalsDropDown.selectionBackgroundColor = .black
        weightLossGoalsDropDown.anchorView = self.weightlossGoalButton
        weightLossGoalsDropDown.dataSource = ["Aggressive Weight Loss", "Moderate Weight Loss", "Weight Loss", "Maintain Weight", "Moderate Weight Gain", "Aggressive Weight Gain"]
        
        
        
        let ageBottomLine = CALayer()
        ageBottomLine.frame = CGRect(x: 0.0, y: ageTextField.frame.height - 1, width: ageTextField.frame.width, height: 1.0)
        ageBottomLine.backgroundColor = UIColor.white.cgColor
        ageTextField.layer.addSublayer(ageBottomLine)
        
        let heightBottomLine = CALayer()
               heightBottomLine.frame = CGRect(x: 0.0, y: heightTextField.frame.height - 1, width: heightTextField.frame.width, height: 1.0)
               heightBottomLine.backgroundColor = UIColor.white.cgColor
               heightTextField.layer.addSublayer(heightBottomLine)
        
        let weightBottomLine = CALayer()
                      weightBottomLine.frame = CGRect(x: 0.0, y: weightTextField.frame.height - 1, width: heightTextField.frame.width, height: 1.0)
                      weightBottomLine.backgroundColor = UIColor.white.cgColor
                      weightTextField.layer.addSublayer(weightBottomLine)
        
        self.weightlossGoalButton.layer.cornerRadius = 10
        self.weightlossGoalButton.layer.borderWidth = 1
        self.weightlossGoalButton.layer.borderColor = UIColor.white.cgColor
        self.exerciseFrequencyButton.layer.borderWidth = 1
        self.exerciseFrequencyButton.layer.borderColor = UIColor.white.cgColor
        self.exerciseFrequencyButton.layer.cornerRadius = 10
        self.doneButton.layer.borderWidth = 1
        self.doneButton.layer.borderColor = UIColor.white.cgColor
        self.doneButton.layer.cornerRadius = 10
    }
    
    @objc func tapped(UITapGesture: UITapGestureRecognizer) {
        self.exerciseFrequencyDropDown.hide()
        self.weightLossGoalsDropDown.hide()
    }
    
    private func verifyAge(age: String) -> Bool {
        //tag1
        if age.isInt && age.count <= 3 {
            return true
        }
        return false
    }
    
    private func verifyHeight(height: String) -> Bool {
        //tag2
        if height.count == 3 {
            for character in height {
                if character.isPunctuation {
                    guard let first = height.first, let last = height.last else {return false}
                    
                    if first.isNumber && last.isNumber {
                        return true
                    }
                }
            }
    }
        return false
}
    
    private func verifyWeight(weight: String) -> Bool {
        //tag3
        if weight.isInt && weight.count <= 3 {
            return true
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = textField.text {
            
            if textField.tag == 1 {
                if !verifyAge(age: text) && !text.isEmpty {
                    let uialert = UIAlertController(title: "Please Input Correct Age", message: nil, preferredStyle:.alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    uialert.addAction(alertAction)
                    self.present(uialert, animated: true, completion: nil)
                }
            } else if textField.tag == 2 {
                if !verifyHeight(height: text) && !text.isEmpty {
                    let uialert = UIAlertController(title: "Please Input Correct Height", message: nil, preferredStyle:.alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    uialert.addAction(alertAction)
                    self.present(uialert, animated: true, completion: nil)
                }
            } else if textField.tag == 3 {
                if !verifyWeight(weight: text) && !text.isEmpty {
                    let uialert = UIAlertController(title: "Please Input Correct Weight", message: nil, preferredStyle:.alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    uialert.addAction(alertAction)
                    self.present(uialert, animated: true, completion: nil)
                }
                
            }
        }
        
    }
    

    @IBAction func muleButtonTapped(_ sender: UIButton) {
        self.maleSelected = true
        self.femaleSelected = false
        let circleImage = UIImage.init(systemName: "circle")
        self.femaleButton.setImage(circleImage, for: .normal)
        let image = UIImage.init(systemName: "largecircle.fill.circle")
        sender.setImage(image, for: .normal)
    }
    
    @IBAction func femaleButtonTapped(_ sender: UIButton) {
        self.femaleSelected = true
        self.maleSelected = false
        let circleImage = UIImage.init(systemName: "circle")
        self.maleButton.setImage(circleImage, for: .normal)
        let image = UIImage.init(systemName: "largecircle.fill.circle")
        sender.setImage(image, for: .normal)
    }
    
    @IBAction func exerciseFrequencyButtonTapped(_ sender: UIButton) {
        self.weightLossGoalsDropDown.hide()
        self.exerciseFrequencyDropDown.show()
        
        self.exerciseFrequencyDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
           sender.setTitle(item, for: .normal)
            
        }
    }
    
    @IBAction func weightlossGoalTapped(_ sender: UIButton) {
        self.exerciseFrequencyDropDown.hide()
        self.weightLossGoalsDropDown.show()
        
        self.weightLossGoalsDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            sender.setTitle(item, for: .normal)
        }
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if let age = self.ageTextField.text, let weight = self.weightTextField.text, let height = self.heightTextField.text {
            if age.isEmpty ||
                weight.isEmpty ||
                height.isEmpty ||
                self.exerciseFrequencyButton.titleLabel?.text == "Exercise Frequency" ||
                self.weightlossGoalButton.titleLabel?.text == "Weightloss Goal" {
                if self.maleSelected == false &&
                self.femaleSelected == false {
                    let uialert = UIAlertController(title: "Please Input Required Information", message: nil, preferredStyle:.alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    uialert.addAction(alertAction)
                    self.present(uialert, animated: true, completion: nil)
                } else if self.maleSelected == true || self.femaleSelected == true {
                    let uialert = UIAlertController(title: "Please Input Required Information", message: nil, preferredStyle:.alert)
                                       let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                       uialert.addAction(alertAction)
                                       self.present(uialert, animated: true, completion: nil)
                }
                       
            } else {
                if self.maleSelected == false && self.femaleSelected == false {
                    let uialert = UIAlertController(title: "Please Input Required Information", message: nil, preferredStyle:.alert)
                                       let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                       uialert.addAction(alertAction)
                                       self.present(uialert, animated: true, completion: nil)
                } else {
                    
           // UserDefaults.standard.set(true, forKey: "didSetup")
                    if let height = heightTextField.text,
                        let weight = weightTextField.text,
                        let age = ageTextField.text,
                        let goal = self.weightlossGoalButton.titleLabel?.text,
                        let exercisefreq = self.exerciseFrequencyButton.titleLabel?.text {
                    
                        var selectedGender = ""
                        if self.maleSelected == true {
                            selectedGender = "Male"
                        } else {
                            selectedGender = "Female"
                        }
                    let macroCalculator = MacroCalculator(height: height, age: age, gender: selectedGender , weight: weight, exerciseFreq: exercisefreq, goal: goal)
                    
                let homeVC = HomeViewController()
                        homeVC.macroCalculator = nil
                        homeVC.macroCalculator = macroCalculator
                      homeVC.modalPresentationStyle = .overFullScreen
                      self.present(homeVC, animated: true, completion: nil)
            }
            }
        }
        }
        
    }
    
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
