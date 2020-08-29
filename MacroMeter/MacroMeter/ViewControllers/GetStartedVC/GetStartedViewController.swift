//
//  GetStartedViewController.swift
//  MacroMeter
//
//  Created by Luqmaan Khan on 8/29/20.
//  Copyright © 2020 Luqmaan Khan. All rights reserved.
//

import UIKit
import DropDown

class GetStartedViewController: UIViewController {

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       prepareUI()
    }
    
    func prepareUI() {
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

    @IBAction func muleButtonTapped(_ sender: UIButton) {
        let circleImage = UIImage.init(systemName: "circle")
        self.femaleButton.setImage(circleImage, for: .normal)
        let image = UIImage.init(systemName: "largecircle.fill.circle")
        sender.setImage(image, for: .normal)
    }
    
    @IBAction func femaleButtonTapped(_ sender: UIButton) {
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
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .overFullScreen
        self.present(homeVC, animated: true, completion: nil)
        
    }
    
}
