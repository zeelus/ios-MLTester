//
//  ViewController.swift
//  EasyImageCaptureExample
//
//  Created by Gilbert Gwizdała on 26.11.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let imageCapture = EasyImageCapture(options: ["autoFocusRangeRestriction": AVCaptureDevice.AutoFocusRangeRestriction.near])
    @IBOutlet weak var imageView: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCapture.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }

}

extension ViewController: EasyImageCaptureDelegate {
    
    var preferredCameraInput: EasyImageInputCameraType {
        return .buidtDual
    }
    
    
    func capture(_ imageCapture: EasyImageCapture, isPermission: Bool) {
        if !isPermission {
            imageCapture.askForPermission()
        }
    }

    func capture(_ imageCapture: EasyImageCapture, frame: CIImage, atTime time: TimeInterval) {
        self.imageView.image = UIImage(ciImage: frame)
    }
    
}

