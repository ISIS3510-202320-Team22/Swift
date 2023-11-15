//
//  CameraContentView.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 27-09-2023.
//

import Foundation
import AVFoundation
import SwiftUI

class CameraService {
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?

    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()

    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkPermissions(completion: completion)
    }
    
    private func checkPermissions(completion: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {[weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setUpCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera(completion: completion)
        @unknown default:
            break;
        }
    }
    
    private func setUpCamera(completion: @escaping (Error?) -> ()) {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            } catch {
                completion(error)
            }
        }
    }
    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        output.capturePhoto(with: settings, delegate: delegate!)
    }
    
    func switchCameraPosition(_ useFrontCamera: Bool) {
        session?.beginConfiguration()

        // Remove the current input
        if let currentInput = session?.inputs.first {
            session?.removeInput(currentInput)
        }

        // Determine the position based on the boolean value
        let newPosition: AVCaptureDevice.Position = useFrontCamera ? .front : .back

        // Find and add the new camera input
        if let newCamera = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: newPosition
        ).devices.first {
            do {
                let newInput = try AVCaptureDeviceInput(device: newCamera)
                if session!.canAddInput(newInput) {
                    session!.addInput(newInput)
                }
            } catch {
                print("Error switching camera: \(error.localizedDescription)")
            }
        }

        session?.commitConfiguration()
    }

}
