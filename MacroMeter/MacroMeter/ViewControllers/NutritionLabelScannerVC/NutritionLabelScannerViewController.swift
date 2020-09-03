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

class NutritionLabelScannerViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    @IBOutlet weak var macrosLabel: UILabel!
    @IBOutlet weak var servingsEatenSlider: UISlider!
    
    @IBOutlet weak var servingsInstructionsLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    var request = VNRecognizeTextRequest()
    var transcript = ""
    let cameraVC = VNDocumentCameraViewController()
    
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
        let uiAlert = UIAlertController(title: "Please Scan A Nutrition Label", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        uiAlert.addAction(action)
        self.present(uiAlert, animated: true) {
            self.macrosLabel.text = ""
        }
    }
    
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
      
        let maximumCandidates = 1
        
        //Parsed Data
        var carbPerServing = ""
        var proteinPerServing = ""
        var fatPerServing = ""
        var caloriesPerServing = ""
        var servingSize = ""
        var servingsPerContainer = ""
        
        
        //calories box
        let caloriesIndeces = (recognizedText.count / 3) - 1
        let topThird = recognizedText[2...caloriesIndeces]
        let caloriesIdentifier = "calories"
        var isLarge = false
        var caloriesText = ""
        var index = 0
        for (_, observation) in topThird.enumerated() {
            guard let candidate = observation.topCandidates(maximumCandidates).first else {continue}
            caloriesText.append(candidate.string)
            if observation.boundingBox.width >= 0.25 && isLarge == false {
                isLarge = true
            } else {
                isLarge = false
            }
        }
        
     
        caloriesText = caloriesText.lowercased()
        print(caloriesText)
        
        //Handle Large Label where there can be up to 6 digits and remove all whitespace
        //find the word calories while tracking its last index.
        //get the last 6 digits
        var range: Range<String.Index>!
        
        for character in caloriesText {
            if caloriesIdentifier.first == character {
                
                let startOfFoundCharacter = caloriesText.index(caloriesText.startIndex, offsetBy: index)
                let lengthOfFoundCharacter = caloriesText.index(caloriesText.startIndex, offsetBy: caloriesText.count + index)
                 range = startOfFoundCharacter..<lengthOfFoundCharacter
                
                if caloriesText[range] == caloriesIdentifier {
                    //get 6 digits
                    
                }
            }
            index += 1
        }
        
 
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
