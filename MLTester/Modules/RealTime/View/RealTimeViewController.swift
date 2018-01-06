//
//  RealTimeViewController.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 06.01.2018.
//  Copyright © 2018 Gilbert Gwizdała. All rights reserved.
//

import UIKit
import EasyImageCapture

class RealTimeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imageCapture = EasyImageCapture()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCapture.delegate = self
    }

}

extension RealTimeViewController : EasyImageCaptureDelegate {
    
    func capture(_ imageCapture: EasyImageCapture, frame: CIImage, atTime time: TimeInterval) {
        self.imageView.image = UIImage(ciImage: frame)
    }
    
    func capture(_ imageCapture: EasyImageCapture, isPermission: Bool) {
        if !isPermission {
            imageCapture.askForPermission()
        }
    }
    
    
}
