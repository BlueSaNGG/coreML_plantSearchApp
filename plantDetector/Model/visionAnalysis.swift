//
//  visionAnalysis.swift
//  plantDetector
//
//  Created by jinqi on 2021/6/23.
//

import UIKit
import Vision
import CoreML

protocol visionAnalysisDelegate {
    func updateTitle(flowerName: String)
}

class visionAnalysis {
    var delegate: visionAnalysisDelegate?
    
    func asyncDetectImage(image: UIImage) {
        let detectQueue = DispatchQueue(label: "detectQueue")
        detectQueue.async {
            self.detect_image(image: image)
        }
    }
    
    private func detect_image(image: UIImage) {
        guard let model = try? VNCoreMLModel(for: MLModel(contentsOf: FlowerClassifier.urlOfModelInThisBundle)) else{
            fatalError("Loading CoreML Model Failed.")
        }
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            if let firstResult = results.first {
                let itemDescription = firstResult.identifier.description
                self.delegate?.updateTitle(flowerName: itemDescription)
            }
        }
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Can not cast to CIImage")
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}
