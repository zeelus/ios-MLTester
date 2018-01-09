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
    var imageAnalyzer: ImageAnalyzer? = nil
    
    var lastTime: TimeInterval = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupDelegates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeDelegates()
    }
    
    fileprivate func setupDelegates() {
        self.imageCapture.delegate = self
        if let model = CoreMLProvider.instance.getCurrentModel() {
            self.imageAnalyzer = ImageAnalyzer(model: model)
            self.imageAnalyzer?.delegate = self
        }
    }
    
    private func removeDelegates() {
        self.imageCapture.delegate = nil
        self.imageAnalyzer?.delegate = nil
        self.imageAnalyzer = nil
    }
    
    override func viewWillLayoutSubviews() {
        self.setupInfoView()
    }
    
    private func setupInfoView() {
        self.infoView.backgroundColor = self.view.backgroundColor
        self.infoView.layer.cornerRadius = self.infoView.bounds.height / 3
    }

}

extension RealTimeViewController : EasyImageCaptureDelegate {
    
    func capture(_ imageCapture: EasyImageCapture, frame: CIImage, atTime time: TimeInterval) {
        let image = UIImage(ciImage: frame)
        self.imageView.image = image
        
        let timeInterval = time - self.lastTime
        
        if !(self.imageAnalyzer?.isCalculating ?? true) && timeInterval >= 1.0 {
            self.imageAnalyzer?.analize(image: image)
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
