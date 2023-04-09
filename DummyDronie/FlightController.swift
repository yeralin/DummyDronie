//
//  FlightController.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import Foundation
import DJISDK

class FlightController: ObservableObject {
    
    func setupAircraftForVirtualSticksMode() {
        guard let aircraft = DJISDKManager.product() as? DJIAircraft else {
            print("Aircraft is not found")
            return
        }
        
        aircraft.flightController?.setVirtualStickModeEnabled(true, withCompletion: { (error) in
            if let error = error {
                log.error("Failed to enable virtual sticks: \(error.localizedDescription)")
            } else {
                log.info("Virtual sticks enabled")
                self.setVirtualStickModeParameters()
            }
        })
    }
    
    private func setVirtualStickModeParameters() {
        guard let aircraft = DJISDKManager.product() as? DJIAircraft else {
            log.error("Aircraft is not found")
            return
        }
        
        aircraft.flightController?.rollPitchCoordinateSystem = DJIVirtualStickFlightCoordinateSystem.body
        aircraft.flightController?.verticalControlMode = DJIVirtualStickVerticalControlMode.position
        aircraft.flightController?.rollPitchControlMode = DJIVirtualStickRollPitchControlMode.angle
    }
    
    func startVerticalTakeoff() {
        guard let aircraft = DJISDKManager.product() as? DJIAircraft else {
            print("Aircraft is not found")
            return
        }
        
        // Define the desired speed and angle for diagonal movement
        let pitch: Float = 5.0  // Forward/backward movement (negative values move the drone backward, positive values move the drone forward)
        let roll: Float = 5.0   // Left/right movement (negative values move the drone to the left, positive values move the drone to the right)
        let yaw: Float = 0.0    // Rotation (negative values rotate the drone counter-clockwise, positive values rotate the drone clockwise)
        let throttle: Float = 1.0 // Throttle (negative values descend, positive values ascend)
        
        let controlData = DJIVirtualStickFlightControlData(pitch: pitch, roll: roll, yaw: yaw, verticalThrottle: throttle)
        
        aircraft.flightController?.send(controlData, withCompletion: { (error) in
            if let error = error {
                log.error("Failed to send virtual sticks command: \(error.localizedDescription)")
            } else {
                log.info("Virtual sticks command sent successfully")
            }
        })
    }
    
    func stopVerticalTakeoff() {
        guard let aircraft = DJISDKManager.product() as? DJIAircraft else {
            print("Aircraft is not found")
            return
        }
        // Set all control values to 0 to stop movement
        let pitch: Float = 0.0
        let roll: Float = 0.0
        let yaw: Float = 0.0
        let throttle: Float = 0.0
        
        let controlData = DJIVirtualStickFlightControlData(pitch: pitch, roll: roll, yaw: yaw, verticalThrottle: throttle)
        
        aircraft.flightController?.send(controlData, withCompletion: { (error) in
            if let error = error {
                log.error("Failed to send stop virtual sticks command: \(error.localizedDescription)")
            } else {
                log.info("Virtual sticks flying stopped")
            }
            // Force disable virtual sticks
            aircraft.flightController?.setVirtualStickModeEnabled(true, withCompletion: { (error) in
                if let error = error {
                    log.error("Failed to enable virtual sticks: \(error.localizedDescription)")
                }
            })
        })
    }
    
}
