//
//  FlightController.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import Foundation
import DJISDK

class FlightController: NSObject, ObservableObject, DJIBatteryDelegate, DJIFlightControllerDelegate {
    
    @Published private(set) var batteryPercentage: Int = 0
    @Published private(set) var altitude: Double = 0
    @Published private(set) var distance: Double = 0
    
    // Initialize the delegates
    override init() {
        super.init()
        guard let aircraft = DJISDKManager.product() as? DJIAircraft else {
            log.error("Aircraft is not found")
            return
        }
        // Set up battery and flightController delegates
        aircraft.battery?.delegate = self
        aircraft.flightController?.delegate = self
    }
    
    func flightController(_ fc: DJIFlightController, didUpdate state: DJIFlightControllerState) {
        altitude = state.altitude
        guard let aircraftLocation = state.aircraftLocation, let homelocation = state.homeLocation else {
            log.error("Unable to fetch aircraft/homelocation coordinates")
            distance = -1
            return
        }
        // Compute distance
        let x = Double(aircraftLocation.coordinate.latitude - homelocation.coordinate.latitude) * 111111
        let y = Double(aircraftLocation.coordinate.longitude - homelocation.coordinate.longitude) * 111111
        distance = sqrt(x * x + y * y)
    }
    
    func battery(_ battery: DJIBattery, didUpdate state: DJIBatteryState) {
        batteryPercentage = Int(state.chargeRemainingInPercent)
    }
    
    func setupAircraftForVirtualSticksMode() {
        guard let aircraft = DJISDKManager.product() as? DJIAircraft else {
            log.error("Aircraft is not found")
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
            log.error("Aircraft is not found")
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
            log.error("Aircraft is not found")
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
