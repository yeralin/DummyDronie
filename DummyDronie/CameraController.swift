//
//  CameraController.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import DJISDK

class CameraController: NSObject, DJICameraDelegate, ObservableObject {
    
    @Published private(set) var isRecording: Bool = false
    
    override init() {
        super.init()
        
        // Set this class as DJICameraDelegate to receive camera updates
        DJISDKManager.product()?.camera?.delegate = self
    }
    
    func startVideoRecording() {
        guard let camera = DJISDKManager.product()?.camera else {
            log.error("Camera not found")
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
