//
//  EasyImageCaptureDelegate.swift
//  EasyImageCapture
//
//  Created by Gilbert Gwizdała on 26.11.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

public protocol EasyImageCaptureDelegate {
    
    func capture(_ imageCapture: EasyImageCapture, frame: CMSampleBuffer, atTime time: TimeInterval)
    
    func caputre(_ imageCapture: EasyImageCapture, error: Error?)
    
    func capture(_ imageCapture: EasyImageCapture, frame: CIImage, atTime time: TimeInterval)
    
    func capture(_ imageCapture: EasyImageCapture, isPermission: Bool)
}

extension EasyImageCaptureDelegate {
    
    func caputre(_ imageCapture: EasyImageCapture, error: Error?) {
        print("[EasyImageCapture]: Error - \(error?.localizedDescription ?? "Unknow error")")
    }
    
    func capture(_ imageCapture: EasyImageCapture, frame: CMSampleBuffer, atTime time: TimeInterval) {
        guard let pixelbuffer = CMSampleBufferGetImageBuffer(frame) else { return }
        let ciImage = CIImage(cvImageBuffer: pixelbuffer)
        DispatchQueue.main.async {
            self.capture(imageCapture, frame: ciImage, atTime: time)
        }
    }
    
    func capture(_ imageCapture: EasyImageCapture, frame: UIImage, atTime time: TimeInterval) { }
    
}
