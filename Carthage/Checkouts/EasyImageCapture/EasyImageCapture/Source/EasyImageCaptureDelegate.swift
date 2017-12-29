//
//  EasyImageCaptureDelegate.swift
//  EasyImageCapture
//
//  Created by Gilbert Gwizdała on 26.11.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import AVFoundation

public protocol EasyImageCaptureDelegate {
    
    func capture(frame: CMSampleBuffer, atTime time: TimeInterval)
    
    func caputre(error: Error?)
    
}
