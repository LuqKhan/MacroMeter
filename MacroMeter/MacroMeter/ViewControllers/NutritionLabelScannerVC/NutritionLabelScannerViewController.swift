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

class NutritionLabelScannerViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    @IBOutlet weak var macrosLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    var request = VNRecognizeTextRequest()
    var transcript = ""
    let cameraVC = VNDocumentCameraViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
      
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            transcript += candidate.string
            transcript += "\n"
        }
        
        self.macrosLabel.text = transcript

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
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        // process image
        
        //only if they have an image, then change label alpha
        //and move camera button to top right
        //because we will have the data we need and it will be displayed
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
