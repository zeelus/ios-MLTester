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
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var classificationName: UILabel!
    @IBOutlet weak var percentValue: UILabel!
    
    let imageCapture = EasyImageCapture()
    var imageAnalyzer: ImageAnalyzer! = nil
    
    var lastTime: TimeInterval = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
    }
    
    fileprivate func setupDelegates() {
        imageCapture.delegate = self
        if let model = CoreMLProvider.instance.getCurrentModel() {
            self.imageAnalyzer = ImageAnalyzer(model: model)
            self.imageAnalyzer.delegate = self
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.setupInfoView()
    }
    
    private func setupInfoView() {
        self.infoView.backgroundColor = self.view.backgroundColor
        self.infoView.layer.cornerRadius = self.infoView.bounds.height / 2
    }

}

extension RealTimeViewController : EasyImageCaptureDelegate {
    
    func capture(_ imageCapture: EasyImageCapture, frame: CIImage, atTime time: TimeInterval) {
        let image = UIImage(ciImage: frame)
        self.imageView.image = image
        
        let timeInterval = time - self.lastTime
        
        if !self.imageAnalyzer.isCalculating && timeInterval >= 1.0 {
            self.imageAnalyzer.analize(image: image)
            self.lastTime = time
        }
        
    }
    
    func capture(_ imageCapture: EasyImageCapture, isPermission: Bool) {
        if !isPermission {
            imageCapture.askForPermission()
        }
    }
    
}

extension RealTimeViewController: ImageAnlalizerDelegate {
    
    func imageAnalyzer(_ imageAnalyzer: ImageAnalyzer, clasyfication name: String, percent value: Int) {
        self.classificationName.text = name
        self.percentValue.text = "\(value) %"
    }
    
    func imageAnalyzer(_ imageAnalyzer: ImageAnalyzer, error: Error) {
        print(error)
    }
    
    
}
