//
//  CoreMLProvider.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 07.01.2018.
//  Copyright © 2018 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import Vision

class CoreMLProvider {
    
    private init() { }
    public static let instance = CoreMLProvider()
    
    func getCurrentModel() -> VNCoreMLModel? {
        return try? VNCoreMLModel(for: Inceptionv3().model)
    }
    
    
}
