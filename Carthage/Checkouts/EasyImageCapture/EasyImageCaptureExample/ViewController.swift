//
//  ViewController.swift
//  EasyImageCaptureExample
//
//  Created by Gilbert Gwizdała on 26.11.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit
import EasyImageCapture
import AVFoundation

class ViewController: UIViewController {
    
    let imageCapture = EasyImageCapture()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCapture.delegate = self
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }

}

extension ViewController: EasyImageCaptureDelegate {
    func capture(frame: CMSampleBuffer, atTime time: TimeInterval) {
        guard let pixelbuffer = CMSampleBufferGetImageBuffer(frame) else { return }
        let ciImage = CIImage(cvImageBuffer: pixelbuffer)
        DispatchQueue.main.async {
            self.imageView.image = UIImage(ciImage: ciImage)
        }
        
    }
    
    func caputre(error: Error?) {
        print(error)
    }
}

