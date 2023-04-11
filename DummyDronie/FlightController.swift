//
//  FlightController.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import Foundation
import DJISDK

/// FlightController class to manage flight control state and to send virtual stick commands
class FlightController: NSObject, ObservableObject, DJIBatteryDelegate, DJIFlightControllerDelegate {
    
    /// Declared properties for batteryPercentage, altitude and distance
    @Published private(set) var virtualSticksEnabled: Bool = false
    @Published private(set) var batteryPercentage: Int = 0
    @Published private(set) var altitude: Double = 0
    @Published private(set) var distance: Double = 0
    
    /// Initialize the delegates
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
    
    /// Sends the virtual stick command to start vertical takeoff
    func startVerticalTakeoff() {
        self.enableAircraftVirtualSticksMode()
        if self.virtualSticksEnabled == false {
            log.error("Cannot perform vertical takeoff while virtual sticks are disabled")
            return
        }
        guard let aircraft = DJISDKManager.product() as? DJIAircraft else {
            log.error("Aircraft is not found")
            return
        }
        
        // Define the desired speed and angle for diagonal movement
        let pitch: Float = 5.0  // Forward/backward movement
        let roll: Float = 5.0   // Left/right movement
        let yaw: Float = 0.0    // Rotation
        let throttle: Float = 1.0 // Throttle
        let controlData = DJIVirtualStickFlightControlData(pitch: pitch, roll: roll, yaw: yaw, verticalThrottle: throttle)
        
        aircraft.flightController?.send(controlData, withCompletion: { (error) in
            if let error = error {
                log.error("Failed to send virtual sticks command: \(error.localizedDescription)")
                return
            }
            log.info("Virtual sticks command sent successfully")
        })
    }
    
    /// Sends the virtual stick command to stop vertical takeoff
    func stopVerticalTakeoff() {
        if self.virtualSticksEnabled == false {
            log.error("Cannot stop vertical takeoff while virtual sticks are disabled")
            return
        }
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
                log.info("Vertical takeoff is stopped")
            }
            // Force disable virtual sticks
            self.disableAircraftVirtualSticksMode()
        })
    }
    
    
    /// Enable virtual stick mode parameters for the flight controller
    private func enableAircraftVirtualSticksMode() {
        if self.virtualSticksEnabled == true {
            log.error("Virtual sticks already disabled")
            disableAircraftVirtualSticksMode()
            return
        }
        guard let aircraft = DJISDKManager.product() as? DJIAircraft else {
            log.error("Aircraft is not found")
            return
        }
        
        aircraft.flightController?.setVirtualStickModeEnabled(true, withCompletion: { (error) in
            if let error = error {
                log.error("Failed to enable virtual sticks: \(error.localizedDescription)")
                self.virtualSticksEnabled = false
                return
            }
            log.info("Virtual sticks enabled")
            aircraft.flightController?.rollPitchCoordinateSystem = DJIVirtualStickFlightCoordinateSystem.body
            aircraft.flightController?.verticalControlMode = DJIVirtualStickVerticalControlMode.position
            aircraft.flightController?.rollPitchControlMode = DJIVirtualStickRollPitchControlMode.angle
            self.virtualSticksEnabled = true
        })
    }
    
    // Disable virtual stick mode for the flight controller
    private func disableAircraftVirtualSticksMode() {
        if self.virtualSticksEnabled == false {
            log.error("Virtual sticks already disabled")
            return
        }
        guard let aircraft = DJISDKManager.product() as? DJIAircraft else {
            log.error("Aircraft is not found")
            return
        }
        aircraft.flightController?.setVirtualStickModeEnabled(false, withCompletion: { (error) in
            if let error = error {
                log.error("Failed to disable virtual sticks: \(error.localizedDescription)")
                return
            }
            log.info("Virtual sticks disabled")
        })
    }
    
    // MARK: - DJIFlightControllerDelegate
    // All methods below called through the delegate
    
    /// didUpdate delegate method for DJIFlightControllerDelegate, updates altitude and distance
    func flightController(_ fc: DJIFlightController, didUpdate state: DJIFlightControllerState) {
        altitude = state.altitude
        guard let aircraftLocation = state.aircraftLocation, let homelocation = state.homeLocation else {
            log.error("Unable to fetch aircraft/homelocation coordinates")
            distance = -1
            return
        }
        // Compute distance
        distance = CLLocation(latitude: aircraftLocation.coordinate.latitude, longitude: aircraftLocation.coordinate.longitude)
            .distance(from: CLLocation(latitude: homelocation.coordinate.latitude, longitude: homelocation.coordinate.longitude))
    }
    
    // MARK: - DJIBatteryDelegate
    // All methods below called through the delegate
    
    /// didUpdate delegate method for DJIBatteryDelegate, updates battery percentage
    func battery(_ battery: DJIBattery, didUpdate state: DJIBatteryState) {
        batteryPercentage = Int(state.chargeRemainingInPercent)
    }
    
}
