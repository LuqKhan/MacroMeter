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

class NutritionLabelScannerViewController: UIViewController, VNDocumentCameraViewControllerDelegate{
    @IBOutlet weak var macrosLabel: UILabel!
    @IBOutlet weak var servingsEatenSlider: UISlider!
    
    @IBOutlet weak var servingsInstructionsLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    
    var request = VNRecognizeTextRequest()
    var transcript = ""
    let cameraVC = VNDocumentCameraViewController()
    let maximumCandidates = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    @IBAction func scanButtonTapped(_ sender: UIButton) {
        self.cameraVC.modalPresentationStyle = .overFullScreen
        self.present(self.cameraVC, animated: true, completion: nil)
    }
    
    private func presentAlert() {
        let uiAlert = UIAlertController(title: "Please Scan Again", message: "Be Sure To Follow The Guidelines On How To Capture A Nutrition Label", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        uiAlert.addAction(action)
        self.present(uiAlert, animated: true) {
            self.macrosLabel.text = ""
        }
    }
    
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        var caloriesPerServing = parseCalories(recognizedText: recognizedText)
        var carbsPerServing = parseCarbs(recognizedText: recognizedText)
        var fatPerServing = parseFat(recognizedText: recognizedText)
        var proteinPerServing = parseProtein(recognizedText: recognizedText)
        var o = ""
    }
    
    
    private func isLargeLabel(candidateString: String) -> Bool {
        if  candidateString.contains("Total Carbohydrate") ||
            candidateString.contains("carbohydrate") ||
            candidateString.contains("Carbohydrate") {
            return true
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
                presentAlert()
            }
            
            
            
        } // FIGURE OUT ALL VARIATIONS OF THE REGEX PATTERN THAT CAN BE USED, ND FOR EACH MATCH FAILURE GO THROUGH UNTIL THE THEY ARE ALL EXHAUSTED AND THEN PRESENT ALERT
        return proteinPerServing
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
                }
                presentAlert()
            }
            
            
            
        } // FIGURE OUT ALL VARIATIONS OF THE REGEX PATTERN THAT CAN BE USED, ND FOR EACH MATCH FAILURE GO THROUGH UNTIL THE THEY ARE ALL EXHAUSTED AND THEN PRESENT ALERT
        return fatPerServing
        
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
        
        //add in hydrate as well as edge case
        //D.N.R -> RECORD ALL VARIATIONS OF THE STRING IN ORDER TO KEEP TRACK OF ALL POSSIBLE PATTTERNS TO BE USED HERE FOR E.G: HYDRATE
        let shortCarbsPattern = "total\\s+carb.\\s+(\\d+)"
        let largeCarbsPattern = "total\\s+carbohydrate(\\d+)"
        let otherCarbsPattern = "total\\s+carbohydrate\\s+(\\d+)"
        //if the regex pattern fails then slice the string out as well as 3 characters ahead
        //
        
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
            } else if let otherRegex = try? NSRegularExpression(pattern: otherCarbsPattern, options: .dotMatchesLineSeparators) {
                if let match = otherRegex.firstMatch(in: carbsText, options: [], range: NSRange(location: 0, length: carbsText.count)) {
                    if let wholeRange = Range(match.range(at: 0), in: carbsText) {
                        let wholeMatch = carbsText[wholeRange]
                        for character in wholeMatch {
                            if character.isNumber {
                                carbPerServing.append(character)
                            }
                        }
                    }
                    
                }
                presentAlert()
            }
    
        
        }
        return carbPerServing
    }
        
        func parseCalories(recognizedText: [VNRecognizedTextObservation]) -> String? {
            
            let maximumCandidates = 1
            var caloriesPerServing = ""
            
            
            //calories box
            //POTENTIAL ERROR!!!!!!!!!!!!!!!! THE COUNT MAY START TOO LATE AND CUT OFF THE CALORIES ON SMALL LABELS!!!!
            let caloriesIndeces = (recognizedText.count / 3) - 1
            let topThird = recognizedText[2...caloriesIndeces]
            var caloriesText = ""
            
            for (_, observation) in topThird.enumerated() {
                guard let candidate = observation.topCandidates(maximumCandidates).first else {continue}
                caloriesText.append(candidate.string)
            }
            
            caloriesText = caloriesText.lowercased()
            print(caloriesText)
            
            let caloriesPattern = "calories(\\d+)"
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
                } // FIGURE OUT ALL VARIATIONS OF THE REGEX PATTERN THAT CAN BE USED, ND FOR EACH MATCH FAILURE GO THROUGH UNTIL THE THEY ARE ALL EXHAUSTED AND THEN PRESENT ALERT
                
                presentAlert()
                
            }
            return caloriesPerServing
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
            print("Editing ended")
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            // process image
            
            
            controller.dismiss(animated: true) {
                //HERE YOU CAN MAKE IT SO ONLY THE VERY LAST IMAGE IS USED.
                DispatchQueue.global(qos: .userInitiated).async {
                    for pageNumber in 0 ..< scan.pageCount {
                        let image = scan.imageOfPage(at: pageNumber)
                        self.processImage(image: image)
                    }
                }
            }
        }
        
    }
    extension Collection where Indices.Iterator.Element == Index {
        subscript (safe index: Index) -> Iterator.Element? {
            return indices.contains(index) ? self[index] : nil
        }
}
