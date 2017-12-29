//
//  CameraCapture.swift
//  mlExample
//
//  Created by Gilbert Gwizdała on 14/09/2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

public class EasyImageCapture: NSObject {
    
    private let cameraQueue = DispatchQueue(label: "cameraQueue")
    private let captureSession = AVCaptureSession()
    
    public var delegate: EasyImageCaptureDelegate? = nil
    
    private var frame: CMSampleBuffer? = nil
    
    private var isPermission = false
    
    override public init() {
        super.init()
        self.checkPermission()
        self.cameraQueue.sync {
            self.setupCameraCapture()
            self.captureSession.startRunning()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.isPermission = true
        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video, completionHandler: {[weak self] (permission) in
//                self?.isPermission = permission
//            })
            self.askForPermission()
        default:
            self.isPermission = false
            self.delegate?.caputre(error: EasyImageCaptureError.accessDenied)
        }
    }
    
    private func askForPermission() {
        self.cameraQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) {[weak self] (isPermission) in
            self?.isPermission = isPermission
            self?.cameraQueue.resume()
        }
    }
    
    private func setupCameraCapture() {
        guard self.isPermission else { return }
        self.captureSession.sessionPreset = .medium
        
        guard let captureDevice = self.selectCaptureDevice() else { return }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        self.captureSession.addInput(captureDeviceInput)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: self.cameraQueue)
        self.captureSession.addOutput(output)
        
        let connection = output.connection(with: .video)
        let deviceOrientation = UIDevice.current.orientation
        connection?.videoOrientation = deviceOrientation.getAVOrietation
        
    }
    
    private func selectCaptureDevice() -> AVCaptureDevice? {
        let devices: [AVCaptureDevice] = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: .video, position: .back).devices
        return devices.first
    }
    
    func resume() {
        self.cameraQueue.sync {
            self.captureSession.startRunning()
        }
    }
    
    func stop() {
        self.cameraQueue.sync {
            self.captureSession.stopRunning()
        }
    }
    
    @objc func orientationChange() {
        print("Chane orientation")
        let connection = self.captureSession.outputs.first?.connection(with: .video)
        let deviceOrientation = UIDevice.current.orientation
        connection?.videoOrientation = deviceOrientation.getAVOrietation
    }
    
}

extension EasyImageCapture : AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.frame = sampleBuffer
        self.delegate?.capture(frame: sampleBuffer, atTime: Date().timeIntervalSince1970)
        
    }
    
}

fileprivate extension UIDeviceOrientation {
    var getAVOrietation: AVCaptureVideoOrientation {
        switch self {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
}
