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
    private let options: [String: Any]?
    
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
    
    public init(options: [String: Any]? = nil) {
        self.options = options
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
        
        if let options = self.options {
            
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.setOptions(options: options)
                captureDevice.unlockForConfiguration()
            } catch {
                print("Capture device lock error")
            }
            
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
        
        guard let prefer = self._delegate?.preferredCameraInput else { return nil }

        var types: [AVCaptureDevice.DeviceType] = [.builtInTelephotoCamera, .builtInWideAngleCamera]
        
        if #available(iOS 10.2, *) {
            types.append(.builtInDualCamera)
        }
        
        if prefer == .front {
            let devices: [AVCaptureDevice] = AVCaptureDevice.DiscoverySession.init(deviceTypes: types, mediaType: .video, position: .front).devices
            return devices.first
        }
        
        let devices: [AVCaptureDevice] = AVCaptureDevice.DiscoverySession.init(deviceTypes: types, mediaType: .video, position: .back).devices
        
        
        return devices.filter { $0.deviceType == prefer.getAVDevice() }.first
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

fileprivate extension AVCaptureDevice {
    
    func setOptions(options: [String: Any]) {
        
        if let focusModeOption = options["focusMode"] as? AVCaptureDevice.FocusMode {
            self.focusMode = focusModeOption
        }
        
        if let focusPointOfInterestOption = options["focusPointOfInterest"] as? CGPoint {
            self.focusPointOfInterest = focusPointOfInterestOption
        }
        
        if let autoFocusRangeRestrictionOption = options["autoFocusRangeRestriction"] as? AVCaptureDevice.AutoFocusRangeRestriction {
            if self.isAutoFocusRangeRestrictionSupported {
                self.autoFocusRangeRestriction = autoFocusRangeRestrictionOption
            }
        }
        
    }
}
