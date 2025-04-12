//
//  PermissionManager.swift
//  Camera SwiftUI Project
//
//  Created by Lidiia Diachkovskaia on 4/11/25.
//

import AVFoundation
import Photos
import UIKit

enum PermissionType {
    case camera, photoLibrary
}

class PermissionManager {
    
    static func checkPermission(for type: PermissionType, completion: @escaping (Bool) -> Void) {
        switch type {
        case .camera:
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                completion(true)
            case .notDetermined:
                DispatchQueue.main.async {
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        completion(granted)
                    }
                    }
                }
            default:
                completion(false)
            }
        case .photoLibrary:
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { newStatus in
                    DispatchQueue.main.async {
                        completion(newStatus == .authorized || newStatus == .limited)
                    }
                }
            case .authorized, .limited:
                completion(true)
            default:
                completion(false)
            }
        
        }
    }
    
    static func openAppSettings() {
        guard let settings = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settings) {
            UIApplication.shared.open(settings)
        }
    }
}


