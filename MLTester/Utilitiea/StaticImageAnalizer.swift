//
//  AnalizeStaticImage.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 30.12.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import Vision
import UIKit


protocol StaticImageAnlalizerDelegate: class {
    func imageClasyfication(name: String)
}

class StaticImageAnalizer {
    
    private let model: VNCoreMLModel
    private var request: VNCoreMLRequest? = nil
    
    weak var delegate: StaticImageAnlalizerDelegate?
    
    init(model: VNCoreMLModel) {
        self.model = model
        self.setupRequest()
    }
    
    func setupRequest() {
        self.request = VNCoreMLRequest(model: model) {[weak self] (request, error) in
            if let observation = request.results?.first as? VNClassificationObservation {
                self?.new(observation)
            }
        }
    }
    
    fileprivate func new(_ observation: VNClassificationObservation) {
        self.delegate?.imageClasyfication(name: observation.identifier)
    }
    
    public func analize(image: UIImage) {
        guard let cgImage = image.cgImage, let request = self.request else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Perform error")
        }
        
    }
}
