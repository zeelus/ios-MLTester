//
//  ImageAnalyzer.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 07.01.2018.
//  Copyright © 2018 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import Vision
import UIKit

protocol ImageAnlalizerDelegate: class {

    func imageAnalyzer(_ imageAnalyzer: ImageAnalyzer, clasyfication name: String, percent value: Int)
    func imageAnalyzer(_ imageAnalyzer: ImageAnalyzer, error: Error)
    
}

class ImageAnalyzer {
    
    public weak var delegate: ImageAnlalizerDelegate? = nil
    
    private let model: VNCoreMLModel
    private var request: VNCoreMLRequest? = nil
    
    private(set) var isCalculating = false
    private var isSetup = false
    
    init(model: VNCoreMLModel) {
        self.model = model
        self.setupRequest()
    }
    
    private func setupRequest() {
        self.request = VNCoreMLRequest(model: self.model) {[weak self] (request, error) in
            
            if let observation = request.results?.first as? VNClassificationObservation {
                self?.new(observation)
            }
            
            self?.isCalculating = false
            
        }
        self.request?.preferBackgroundProcessing = true
        self.isSetup = true
    }
    
    public func analize(image: UIImage) {
        
        DispatchQueue.global(qos: .background).async {
            
            guard self.isCalculating == false && self.isSetup == true else { return }
            self.isCalculating = true
            
            guard  let request = self.request else { return }
            
            var handler: VNImageRequestHandler? = nil
            
            if let ciImage = image.ciImage {
                handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            } else if let cgImage = image.cgImage {
                handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            }
            
            do {
                try handler?.perform([request])
            } catch {
                print("Perform error")
            }
        }
        
    }
    
    fileprivate func new(_ observation: VNClassificationObservation) {
        let name = observation.identifier
        let percent = Int((observation.confidence * 100.0).rounded())
        DispatchQueue.main.async {
            self.delegate?.imageAnalyzer(self, clasyfication: name, percent: percent)
        }
    }
    
}
