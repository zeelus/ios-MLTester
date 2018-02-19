//
//  CoreMLProvider.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 07.01.2018.
//  Copyright © 2018 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import Vision

fileprivate struct MLModelWrapperLocal: MLModelWrapper {
    let name: String
    let model: MLModel
}

class CoreMLProvider {
    
    private let installedModels: [MLModelWrapper] = [
        MLModelWrapperLocal(name: "Inceptionv3", model: Inceptionv3().model),
        MLModelWrapperLocal(name: "SqueezeNet", model: SqueezeNet().model)
    ]
    
    private var selectedModel: MLModelWrapper? = nil
    
    private init() {
        self.selectedModel = self.installedModels.first
    }
    public static let instance = CoreMLProvider()
    
    func getCurrentModel() -> VNCoreMLModel? {
        if let selected = self.selectedModel {
            return try? VNCoreMLModel(for: selected.model)
        }
        
        return nil
    }
        
    func getSelectedModel() -> MLModelWrapper? {
        return self.selectedModel
    }
    
    func getMLModelArray() -> [MLModelWrapper] {
        return self.installedModels
    }
    
    func setMLModel(_ model: MLModelWrapper) {
        self.selectedModel = model
    }
    
}
