//
//  NutritionLabelScannerViewController.swift
//  MacroMeter
//
//  Created by Luqmaan Khan on 8/31/20.
//  Copyright © 2020 Luqmaan Khan. All rights reserved.
//

import UIKit
import Vision
import VisionKit
import NaturalLanguage

protocol NutritionDataDelegate {
    func retrieveNutritionData(fat: Double, protein: Double, carbs: Double, cals: Double) 
}

class NutritionLabelScannerViewController: UIViewController, VNDocumentCameraViewControllerDelegate{
    
    @IBOutlet var instructionView: UIView!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var servingSizeValue: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    
    @IBOutlet weak var fatLabel: UILabel!
    
    @IBOutlet weak var servingsEatenSlider: UISlider!
    
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var blueCalories: UIView!
    @IBOutlet weak var servingsInstructionsLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var proteinGreen: UIView!
    @IBOutlet weak var yellowFat: UIView!
    var request = VNRecognizeTextRequest()
    var transcript = ""
    @IBOutlet weak var carbRed: UIView!
    var cameraVC: VNDocumentCameraViewController!
    let maximumCandidates = 1
    var servingSize: Double?
    var doubleCarbs: Double?
    var doubleFat: Double?
    var doubleProtein: Double?
    var doubleCals: Double?
    var finalCals: Double?
    var finalCarbs: Double?
    var finalFat: Double?
    var finalProtein: Double?
    var delegate: NutritionDataDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.helpButton.layer.cornerRadius = 10
        self.helpButton.layer.borderWidth = 1
        self.helpButton.layer.borderColor = UIColor.white.cgColor
        self.saveButton.layer.cornerRadius = 10
        self.saveButton.layer.borderWidth = 1
        self.saveButton.layer.borderColor = UIColor.white.cgColor
        self.servingSizeValue.alpha = 0
        blueCalories.layer.cornerRadius = 3
        proteinGreen.layer.cornerRadius = 3
        carbRed.layer.cornerRadius = 3
        yellowFat.layer.cornerRadius = 3
        self.hideLabels()
        
        cameraVC = VNDocumentCameraViewController()
        
        self.servingsInstructionsLabel.alpha = 0
        self.servingsEatenSlider.alpha = 0
        self.scanButton.layer.cornerRadius = 12
        self.scanButton.layer.borderWidth = 1
        self.scanButton.layer.borderColor = UIColor.white.cgColor
        self.cameraVC.delegate = self
        request = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    DispatchQueue.main.async {
                        self.addRecognizedText(recognizedText: requestResults)
                    }
                }
            }
        })
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
    }
    @IBAction func helpButtonTapped(_ sender: UIButton) {
        self.view.addSubview(instructionView)
    }
    
    @IBAction func exitInstructionsTapped(_ sender: UIButton) {
        self.instructionView.removeFromSuperview()
    }
    
    
    @IBAction func scanButtonTapped(_ sender: UIButton) {
        self.cameraVC.modalPresentationStyle = .overFullScreen
        self.present(self.cameraVC, animated: true, completion: nil)
    }
    
    
    private func presentAlert() {
        let uiAlert = UIAlertController(title: "Please Scan Again", message: "Please tap the 'Help' button for guidelines on how to capture a nutrition label.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        uiAlert.addAction(action)
        self.present(uiAlert, animated: true) {
            self.hideLabels()
        }
    }
    
    private func hideLabels() {
        self.saveButton.alpha = 0
        self.caloriesLabel.alpha = 0
        self.blueCalories.alpha = 0
        self.proteinLabel.alpha = 0
        self.fatLabel.alpha = 0
        self.carbsLabel.alpha = 0
        self.proteinGreen.alpha = 0
        self.carbRed.alpha = 0
        self.yellowFat.alpha = 0
        self.servingsEatenSlider.alpha = 0
        self.servingSizeValue.alpha = 0
        self.servingsInstructionsLabel.alpha = 0
    }
    
    private func showLabels() {
        
        self.saveButton.alpha = 1
        self.blueCalories.alpha = 1
        self.caloriesLabel.alpha = 1
        self.proteinLabel.alpha = 1
        self.fatLabel.alpha = 1
        self.carbsLabel.alpha = 1
        self.proteinGreen.alpha = 1
        self.carbRed.alpha = 1
        self.yellowFat.alpha = 1
        self.servingsEatenSlider.alpha = 1
        self.servingSizeValue.alpha = 1
        self.servingsInstructionsLabel.alpha = 1
    }
    
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        showLabels()
        
        if let calories = parseCalories(recognizedText: recognizedText),
            let caloriesPerServing = Double(calories),
            let carbs = parseCarbs(recognizedText: recognizedText),
            let carbsPerServing = Double(carbs),
            let fat = parseFat(recognizedText: recognizedText),
            let fatPerServing = Double(fat),
            let protein = parseProtein(recognizedText: recognizedText),
            let proteinPerServing = Double(protein){
            
            self.doubleFat = fatPerServing
            self.doubleCals = caloriesPerServing
            self.doubleCarbs = carbsPerServing
            self.doubleProtein = proteinPerServing
            
            self.caloriesLabel.text = "Calories: \(caloriesPerServing )"
            self.proteinLabel.text = "Protein: \(proteinPerServing )g"
            self.carbsLabel.text = "Carbohydrate: \(carbsPerServing )g"
            self.fatLabel.text = "Fat: \(fatPerServing )g"
            
            let intVal = Int(self.servingsEatenSlider.value)
            self.servingSizeValue.text = "\(intVal)"
            self.servingsEatenSlider.alpha = 1
            self.servingSizeValue.alpha = 1
            self.servingsEatenSlider.maximumValue = 20.5
            self.servingsEatenSlider.minimumValue = 0.25
            self.servingsInstructionsLabel.alpha = 1
            
        } else {
            self.hideLabels()
            presentAlert()
        }
        
    }
    
    
    private func isLargeLabel(candidateString: String) -> Bool {
        if  candidateString.contains("Total Carbohydrate") ||
            candidateString.contains("carbohydrate") ||
            candidateString.contains("Carbohydrate") {
            return true
        }
        return false
    }
    
    func isNutritionLabel(recognizedText: [VNRecognizedTextObservation]) -> Bool {
        
        let indeces = (recognizedText.count / 3) - 1
        let topThird = recognizedText[0...indeces]
        for (_, observation) in topThird.enumerated() {
            guard let candidate = observation.topCandidates(maximumCandidates).first else {continue}
            print(candidate.string)
            if candidate.string.contains("Nutrition Facts") ||
                candidate.string.contains("nutrition facts") ||
                candidate.string.contains("NutritionFacts") ||
                candidate.string.contains("nutritionfacts") ||
                candidate.string.contains("nutrition") || candidate.string.contains("facts") || candidate.string.contains("Nutrition") || candidate.string.contains("Facts") {
                return true
            }
        }
        return false
        
    }
    
    func parseProtein(recognizedText: [VNRecognizedTextObservation]) -> String? {
        var proteinPerServing = ""
        var proteinText = ""
        var isLarge = false
        
        for (_,observation) in recognizedText.enumerated() {
            guard let candidate = observation.topCandidates(maximumCandidates).first else {continue}
            proteinText.append(candidate.string)
            if isLargeLabel(candidateString: candidate.string) && isLarge == false {
                isLarge = true
            }
        }
        
        proteinText = proteinText.lowercased()
        let longProteinPattern = "protein\\s+(\\d+)"
        let shortProteinPattern = "protein(\\d+)"
        
        if let regex = try? NSRegularExpression(pattern: longProteinPattern, options: .init()) {
            if let match = regex.firstMatch(in: proteinText, options: [], range: NSRange(location: 0, length: proteinText.count)) {
                
                if let wholeRange = Range(match.range(at: 0), in: proteinText) {
                    let wholeMatch = proteinText[wholeRange]
                    for character in wholeMatch {
                        if character.isNumber {
                            proteinPerServing.append(character)
                        }
                    }
                }
            } else if let secondRegex = try? NSRegularExpression(pattern: shortProteinPattern, options: .init()) {
                if let match = secondRegex.firstMatch(in: proteinText, options: [], range: NSRange(location: 0, length: proteinText.count)) {
                    if let wholeRange = Range(match.range(at: 0), in: proteinText) {
                        let wholeMatch = proteinText[wholeRange]
                        for character in wholeMatch {
                            if character.isNumber {
                                proteinPerServing.append(character)
                            }
                        }
                    }
                }
            }
        }
        
        if proteinPerServing != "" {
            return proteinPerServing
        } else {
            return nil
        }
    }
    
    func parseFat(recognizedText: [VNRecognizedTextObservation]) -> String? {
        var fatPerServing = ""
        var fatText = ""
        var isLarge = false
        
        for (_,observation) in recognizedText.enumerated() {
            guard let candidate = observation.topCandidates(maximumCandidates).first else {continue}
            fatText.append(candidate.string)
            if isLargeLabel(candidateString: candidate.string) && isLarge == false {
                isLarge = true
            }
        }
        fatText = fatText.lowercased()
        let longFatPattern = "total\\s+fat\\s+(\\d+)"
        let shortFatPattern =  "total\\s+fat(\\d+)"
        let cutOffFatPattern = "fat\\s+(\\d+)"
        
        if let regex = try? NSRegularExpression(pattern: longFatPattern, options: .init()) {
            if let match = regex.firstMatch(in: fatText, options: [], range: NSRange(location: 0, length: fatText.count)) {
                
                if let wholeRange = Range(match.range(at: 0), in: fatText) {
                    let wholeMatch = fatText[wholeRange]
                    for character in wholeMatch {
                        if character.isNumber {
                            fatPerServing.append(character)
                        }
                    }
                }
            } else if let secondRegex = try? NSRegularExpression(pattern: shortFatPattern, options: .init()) {
                if let match = secondRegex.firstMatch(in: fatText, options: [], range: NSRange(location: 0, length: fatText.count)) {
                    if let wholeRange = Range(match.range(at: 0), in: fatText) {
                        let wholeMatch = fatText[wholeRange]
                        for character in wholeMatch {
                            if character.isNumber {
                                fatPerServing.append(character)
                            }
                        }
                    }
                } else if let thirdRegex = try? NSRegularExpression(pattern: cutOffFatPattern, options: .init()) {
                    if let match = thirdRegex.firstMatch(in: fatText, options: [], range: NSRange(location: 0, length: fatText.count)) {
                        if let wholeRange = Range(match.range(at: 0), in: fatText) {
                            let wholeMatch = fatText[wholeRange]
                            for character in wholeMatch {
                                if character.isNumber {
                                    fatPerServing.append(character)
                                }
                            }
                        }
                    }
                }
                
            }
        }
        
        if fatPerServing != "" {
            return fatPerServing
        } else {
            return nil
        }
        
    }
    
    
    func parseCarbs(recognizedText: [VNRecognizedTextObservation]) -> String? {
        
        var carbPerServing = ""
        
        var carbsText = ""
        var isLarge = false
        
        for (_, observation) in recognizedText.enumerated() {
            guard let candidate = observation.topCandidates(maximumCandidates).first else {continue}
            carbsText.append(candidate.string)
            if candidate.string.contains("Total Carbohydrate") || candidate.string.contains("carbohydrate") ||
                candidate.string.contains("Carbohydrate") &&
                isLarge == false {
                isLarge = true
                
            }
            
        }
        
        carbsText = carbsText.lowercased()
        print(carbsText)
        
        let shortCarbsPattern = "total\\s+carb.\\s+(\\d+)"
        let largeCarbsPattern = "total\\s+carbohydrate(\\d+)"
        let otherLongCarbsPattern = "total\\s+carbohydrate\\s+(\\d+)"
        let otherShortCarbsPattern = "total\\s+carb.(\\d+)"
        
        var mutableCarbsPattern = ""
        if isLarge {
            mutableCarbsPattern = largeCarbsPattern
        } else {
            mutableCarbsPattern = shortCarbsPattern
        }
        
        
        if let regex = try? NSRegularExpression(pattern: mutableCarbsPattern, options: .dotMatchesLineSeparators) {
            if let match = regex.firstMatch(in: carbsText, options: [], range: NSRange(location: 0, length: carbsText.count)) {
                
                if let wholeRange = Range(match.range(at: 0), in: carbsText) {
                    let wholeMatch = carbsText[wholeRange]
                    for character in wholeMatch {
                        if character.isNumber {
                            carbPerServing.append(character)
                        }
                    }
                }
            } else if let otherRegex = try? NSRegularExpression(pattern: otherLongCarbsPattern, options: .dotMatchesLineSeparators) {
                if let match = otherRegex.firstMatch(in: carbsText, options: [], range: NSRange(location: 0, length: carbsText.count)) {
                    if let wholeRange = Range(match.range(at: 0), in: carbsText) {
                        let wholeMatch = carbsText[wholeRange]
                        for character in wholeMatch {
                            if character.isNumber {
                                carbPerServing.append(character)
                            }
                        }
                    }
                    
                } else if let otherShortRegex = try? NSRegularExpression(pattern: otherShortCarbsPattern, options: .dotMatchesLineSeparators) {
                    if let match = otherShortRegex.firstMatch(in: carbsText, options: [], range: NSRange(location: 0, length: carbsText.count)) {
                        if let wholeRange = Range(match.range(at: 0), in: carbsText) {
                            let wholeMatch = carbsText[wholeRange]
                            for character in wholeMatch {
                                if character.isNumber {
                                    carbPerServing.append(character)
                                }
                            }
                        }
                    }
                }
            }
            
            
        }
        if carbPerServing != "" {
            return carbPerServing
        } else {return nil}
    }
    
    func parseCalories(recognizedText: [VNRecognizedTextObservation]) -> String? {
        
        let maximumCandidates = 1
        var caloriesPerServing = ""
        
        let caloriesIndeces = (recognizedText.count / 2) - 1
        let topThird = recognizedText[2...caloriesIndeces]
        var caloriesText = ""
        var isLarge = false
        
        
        for (_, observation) in topThird.enumerated() {
            guard let candidate = observation.topCandidates(maximumCandidates).first else {continue}
            if isLargeLabel(candidateString: candidate.string) && isLarge == false {
                isLarge = true
            }
        }
        for (_, observation) in recognizedText.enumerated() {
            guard let candidate = observation.topCandidates(maximumCandidates).first else {continue}
            caloriesText.append(candidate.string)
        }
        
        caloriesText = caloriesText.lowercased()
        print(caloriesText)
        
        let caloriesPattern = "calories(\\d+)"
        let longCaloriesPattern = "calories\\s+(\\d+)"
        //per serving90
        let perServingCaloriesPattern = "per\\s+serving(\\d+)"
        let shortPerServingCaloriesPattern = "serving\\s+(\\d+)"
        let cutOffPerServingCaloriesPattern = "serving(\\d+)"
        if let regex = try? NSRegularExpression(pattern: caloriesPattern, options: .allowCommentsAndWhitespace) {
            if let match = regex.firstMatch(in: caloriesText, options: [], range: NSRange(location: 0, length: caloriesText.count)) {
                
                if let wholeRange = Range(match.range(at: 0), in: caloriesText) {
                    let wholeMatch = caloriesText[wholeRange]
                    for character in wholeMatch {
                        if character.isNumber {
                            caloriesPerServing.append(character)
                        }
                    }
                }
            } else if let secondRegex = try? NSRegularExpression(pattern: longCaloriesPattern, options: .allowCommentsAndWhitespace) {
                if let secondMatch = secondRegex.firstMatch(in: caloriesText, options: [], range: NSRange(location: 0, length: caloriesText.count)) {
                    if let wholeRange = Range(secondMatch.range(at: 0), in: caloriesText) {
                        let wholeMatch = caloriesText[wholeRange]
                        for character in wholeMatch {
                            if character.isNumber {
                                caloriesPerServing.append(character)
                            }
                        }
                    }
                } else if let thirdRegex = try? NSRegularExpression(pattern: perServingCaloriesPattern, options: .init()) {
                    if let match = thirdRegex.firstMatch(in: caloriesText, options: [], range: NSRange(location: 0, length: caloriesText.count)) {
                        
                        if let wholeRange = Range(match.range(at: 0), in: caloriesText) {
                            let wholeMatch = caloriesText[wholeRange]
                            for character in wholeMatch {
                                if character.isNumber {
                                    caloriesPerServing.append(character)
                                }
                            }
                        }
                    } else if let fourthRegex = try? NSRegularExpression(pattern: shortPerServingCaloriesPattern, options: .init()) {
                        if let match = fourthRegex.firstMatch(in: caloriesText, options: [], range: NSRange(location: 0, length: caloriesText.count)) {
                            
                            if let wholeRange = Range(match.range(at: 0), in: caloriesText) {
                                let wholeMatch = caloriesText[wholeRange]
                                for character in wholeMatch {
                                    if character.isNumber {
                                        caloriesPerServing.append(character)
                                    }
                                }
                            }
                        } else if let fifthRegex = try? NSRegularExpression(pattern: cutOffPerServingCaloriesPattern, options: .init()) {                            if let match = fifthRegex.firstMatch(in: caloriesText, options: [], range: NSRange(location: 0, length: caloriesText.count)) {
                                
                                if let wholeRange = Range(match.range(at: 0), in: caloriesText) {
                                    let wholeMatch = caloriesText[wholeRange]
                                    for character in wholeMatch {
                                        if character.isNumber {
                                            caloriesPerServing.append(character)
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                    }
                }
            }
        }
            if caloriesPerServing != "" {
                return caloriesPerServing
            } else {return nil}
        }
        
        
        
        func processImage(image: UIImage) {
            guard let cgImage = image.cgImage else {
                print("Failed to get cgimage from input image")
                return
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
        @IBAction func sliderEnded(_ sender: UISlider) {
            
            let value = Double(sender.value).rounded(toPlaces: 1)
            
            if let doubleCarbs = self.doubleCarbs,
                let doubleFat = self.doubleFat,
                let doubleCals = self.doubleCals,
                let doubleProtein = self.doubleProtein {
                
                let carbsPerServing = doubleCarbs.rounded(toPlaces: 1) * value
                let fatPerServing = doubleFat.rounded(toPlaces: 1) * value
                let caloriesPerServing = doubleCals.rounded(toPlaces: 1) * value
                let proteinPerServing = doubleProtein.rounded(toPlaces: 1) * value
                
                self.proteinLabel.text = "Protein: \(proteinPerServing.rounded(toPlaces: 1))g"
                self.carbsLabel.text = "Carbohydrate: \(carbsPerServing.rounded(toPlaces: 1))g"
                self.caloriesLabel.text = "Calories: \(caloriesPerServing.rounded(toPlaces: 1))"
                self.fatLabel.text = "Fat: \(fatPerServing.rounded(toPlaces: 1))g"
                self.servingSizeValue.text = "\(value.rounded(toPlaces: 1))"
                
                self.finalFat = fatPerServing
                self.finalCals = caloriesPerServing
                self.finalCarbs = carbsPerServing
                self.finalProtein = proteinPerServing
            }
            
            
        }
        
        @IBAction func saveButtonTapped(_ sender: UIButton) {
            if let proteinPerServing = self.finalProtein,
                let fatPerServing = self.finalFat,
                let carbsPerServing = self.finalCarbs,
                let caloriesPerServing = self.finalCals {
                self.delegate?.retrieveNutritionData(fat: fatPerServing, protein: proteinPerServing, carbs: carbsPerServing, cals: caloriesPerServing)
                self.hideLabels()
                self.dismiss(animated: true, completion: nil)
                
            }
             self.dismiss(animated: true, completion: nil)
            
        }
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true) {
                DispatchQueue.global(qos: .userInitiated).async {
                    for pageNumber in 0 ..< scan.pageCount {
                        let image = scan.imageOfPage(at: pageNumber)
                        self.processImage(image: image)
                    }
                }
            }
        }
        @IBAction func cancelTapped(_ sender: UIButton) {
            self.hideLabels()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    extension Collection where Indices.Iterator.Element == Index {
        subscript (safe index: Index) -> Iterator.Element? {
            return indices.contains(index) ? self[index] : nil
        }
    }
    
    extension Double {
        func rounded(toPlaces places:Int) -> Double {
            let divisor = pow(10.0, Double(places))
            return (self * divisor).rounded() / divisor
        }
}

