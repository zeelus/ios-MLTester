//
//  CoreMLWrapper.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 19.02.2018.
//  Copyright © 2018 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import CoreML

protocol MLModelWrapper {
    
    var name: String { get }
    var model: MLModel { get }
    
}


