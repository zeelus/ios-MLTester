//
//  StoryboardManger.swift
//  MLTester
//
//  Created by Gilbert Gwizdała on 29.12.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import UIKit

struct StoryboardManager {
    private init() {}
    
    private struct Types {
        private init(){}
        static let getImageCamera = StoryboardElement(storyboardName: "GetImage", type: ImageAnalizeCameraViewController.self)
        static let reatTime = StoryboardElement(storyboardName: "RealTime", type: RealTimeViewController.self)
        static let listView = StoryboardElement(storyboardName: "ListView", type: CoreMLListViewController.self)
    }
    
}

extension StoryboardManager {
    
    static func getImageCamera() -> ImageAnalizeCameraViewController {
        let vc = Types.getImageCamera.viewController(withIdentifier: "ImageAnalize")
        vc.inputType = .camera
        return vc
    }
    
    static func getImageGallery() -> ImageAnalizeCameraViewController {
        let vc = Types.getImageCamera.viewController(withIdentifier: "ImageAnalize")
        vc.inputType = .photoLibrary
        return vc
    }
    
    static func getRealTime() -> RealTimeViewController {
        return Types.reatTime.viewController()
    }
    
    static func getCoreMLList() -> CoreMLListViewController {
        return Types.listView.viewController()
    }
    
}

fileprivate struct StoryboardElement<T: UIViewController> {
    
    let storyboardName: String
    let type: T.Type
    
    func viewController(withIdentifier viewControllerIdentifier: String? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let identifier = viewControllerIdentifier {
            return storyboard.instantiateViewController(withIdentifier: identifier) as! T
        } else {
            return storyboard.instantiateInitialViewController() as! T
        }
    }
}

