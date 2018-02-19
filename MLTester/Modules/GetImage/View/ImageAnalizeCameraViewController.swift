//
//  GetImageCameraViewController.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 29.12.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit

class ImageAnalizeCameraViewController: UIViewController {
    
    public var inputType = UIImagePickerControllerSourceType.camera
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var clasyficationLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var imageAnalizer: ImageAnalyzer? = nil

    var pickedImage: UIImage? = nil
    
    private var isCancle = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = CoreMLProvider.instance.getCurrentModel() {
            self.imageAnalizer = ImageAnalyzer(model: model)
            self.imageAnalizer?.delegate = self
        }
        
    }
    
    fileprivate func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.inputType
        imagePicker.delegate = self
        self.showDetailViewController(imagePicker, sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if self.isCancle {
            self.navigationController?.popViewController(animated: true)
        }
        
        if self.pickedImage == nil {
            self.showImagePicker()
        }
    }
    
    fileprivate func analizeImage() {
        
        DispatchQueue.main.async {
            self.setImage()
        }
        
        if let image = self.pickedImage {
            self.imageAnalizer?.analize(image: image)
        }
        
    }
    
    private func setImage() {
        self.imageView.image = self.pickedImage
        self.imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5) {
            self.imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @IBAction func retakeButtonPressed(_ sender: Any) {
        self.clasyficationLabel.text = nil
        self.imageView.image = nil
        self.showImagePicker()
    }
}

extension ImageAnalizeCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion:
            { [weak self] in
                self?.analizeImage()
            }
        )
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isCancle = true
    }
    
}

extension ImageAnalizeCameraViewController: ImageAnlalizerDelegate {
    
    
    func imageAnalyzer(_ imageAnalyzer: ImageAnalyzer, clasyfication name: String, percent value: Int) {
        self.indicator.stopAnimating()
        self.clasyficationLabel.text = name
    }
    
    func imageAnalyzer(_ imageAnalyzer: ImageAnalyzer, error: Error) {
        print(error)
    }
    
}
