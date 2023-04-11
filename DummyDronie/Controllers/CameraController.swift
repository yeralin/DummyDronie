//
//  CameraController.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import DJISDK

class CameraController: NSObject, DJICameraDelegate, ObservableObject {
    
    @Published private(set) var isRecording: Bool = false
    
    /// Setup  the delegates upon drone connection
    func setupDelegates(retry: Int = 5, delay: Double = 5) {
        // Set this class as DJICameraDelegate to receive camera updates
        guard let camera = DJISDKManager.product()?.camera else {
            log.error("Camera not found")
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                guard retry > 0 else {
                    log.error("Failed to setup delegates after multiple attempts")
                    return
                }
                self.setupDelegates(retry: retry - 1)
            }
            return
        }
        camera.delegate = self
        log.info("Successfully set camera delegates")
    }
    
    func startVideoRecording() {
        guard let camera = DJISDKManager.product()?.camera else {
            log.error("Camera not found")
            return
        }
        camera.setFlatMode(.videoNormal) { (error) in
            if let error = error {
                log.error("Failed to set camera to video mode: \(error.localizedDescription)")
                return
            }
            camera.startRecordVideo(completion: { (error) in
                if let error = error {
                    log.error("Failed to start video recording: \(error.localizedDescription)")
                } else {
                    log.info("Video recording started")
                }
            })
        }
    }
    
    func stopVideoRecording() {
        guard let camera = DJISDKManager.product()?.camera else {
            log.error("Camera not found")
            return
        }
        
        camera.stopRecordVideo(completion: { (error) in
            if let error = error {
                log.error("Failed to stop video recording: \(error.localizedDescription)")
            } else {
                log.info("Video recording stopped")
            }
        })
    }
    
    // MARK: - DJICameraDelegate
    func camera(_ camera: DJICamera, didUpdate systemState: DJICameraSystemState) {
        // Update isRecording property based on camera system state
        isRecording = systemState.isRecording
    }
    
}
