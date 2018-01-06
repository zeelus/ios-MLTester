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
    
    private var _delegate: EasyImageCaptureDelegate? = nil
    public var delegate: EasyImageCaptureDelegate? {
        
        set {
            
            self._delegate = newValue
            
            if self._delegate != nil {
                self.checkPermission()
            }
            
        }
        
        get{
            return self._delegate
        }
        
    }
    
    private var frame: CMSampleBuffer? = nil
    
    private var isPermission = false
    private var isSetup = false
    
    override public init() {
        super.init()
        self.stop()
        
    }
    
    private func checkPermission() {
        DispatchQueue.main.async {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.isPermission = true
                self.delegate?.capture(self, isPermission: true)
                self.setupCameraCapture()
                self.resume()
            case .notDetermined:
                self.delegate?.capture(self, isPermission: false)
            default:
                self.isPermission = false
                self.delegate?.caputre(self, error: EasyImageCaptureError.accessDenied)
            }
        }

    }
    
    public func askForPermission() {
        AVCaptureDevice.requestAccess(for: .video) {[weak self] (isPermission) in
                self?.isPermission = isPermission
                if isPermission {
                    self?.checkPermission()
                }
        }
    }
    
    private func setupCameraCapture() {
        guard self.isPermission && !self.isSetup else { return }
        self.captureSession.sessionPreset = .medium
        
        guard let captureDevice = self.selectCaptureDevice() else { return }
        
        do {
            try captureDevice.lockForConfiguration()
        } catch {
            print("Capture device lock error")
        }
        
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        self.captureSession.addInput(captureDeviceInput)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: self.cameraQueue)
        self.captureSession.addOutput(output)
        
        let connection = output.connection(with: .video)
        let deviceOrientation = UIDevice.current.orientation
        connection?.videoOrientation = deviceOrientation.getAVOrietation
        
        self.isSetup = true
    }
    
    private func selectCaptureDevice() -> AVCaptureDevice? {
        
        var types: [AVCaptureDevice.DeviceType] = [.builtInTelephotoCamera, .builtInWideAngleCamera]
        
        if #available(iOS 10.2, *) {
            types.append(.builtInDualCamera)
        }
        
        let devices: [AVCaptureDevice] = AVCaptureDevice.DiscoverySession.init(deviceTypes: types, mediaType: .video, position: .back).devices
        return devices.first
    }
    
    public func resume() {
        self.cameraQueue.sync {
            self.captureSession.startRunning()
        }
    }
    
    public func stop() {
        self.cameraQueue.sync {
            self.captureSession.stopRunning()
        }
    }
    
}

extension EasyImageCapture : AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        self.frame = sampleBuffer
        self.delegate?.capture(self, frame: sampleBuffer, atTime: Date().timeIntervalSince1970)
        
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

