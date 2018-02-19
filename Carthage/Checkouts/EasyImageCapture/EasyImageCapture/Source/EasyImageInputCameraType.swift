//
//  EasyImageInputCameraType.swift
//  EasyImageCapture
//
//  Created by Gilbert Gwizdała on 28.01.2018.
//  Copyright © 2018 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import AVFoundation

public enum EasyImageInputCameraType {
    case front
    case telephoto
    case wideAngle
    case buidtDual
}

extension EasyImageInputCameraType {
    func getAVDevice() -> AVCaptureDevice.DeviceType {
        switch self {
        case .telephoto:
            return AVCaptureDevice.DeviceType.builtInTelephotoCamera
        case .wideAngle:
            return AVCaptureDevice.DeviceType.builtInWideAngleCamera
        case .buidtDual:
            if #available(iOS 10.2, *) {
                return AVCaptureDevice.DeviceType.builtInDualCamera
            } else {
                return AVCaptureDevice.DeviceType.builtInWideAngleCamera
            }
        default:
            return AVCaptureDevice.DeviceType.builtInWideAngleCamera
        }
    }
}
