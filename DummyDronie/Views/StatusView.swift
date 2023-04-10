//
//  StatusView.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import SwiftUI


struct StatusView: View {
    
    @ObservedObject var flightController: FlightController
    @ObservedObject var cameraController: CameraController
    
    var batteryImage: Image {
        switch flightController.batteryPercentage {
        case 76...100:
            return Image(systemName: "battery.100")
        case 51...75:
            return Image(systemName: "battery.75")
        case 26...50:
            return Image(systemName: "battery.50")
        case 10...25:
            return Image(systemName: "battery.25")
        default:
            return Image(systemName: "battery.0")
        }
    }
    
    var body: some View {
        HStack {
            HStack {
                batteryImage
                Text("\(flightController.batteryPercentage)%")
            }
            Text("D \(flightController.distance, specifier: "%.0f") m")
            Text("Alt \(flightController.altitude, specifier : "%.0f") m")
        }
        .bold()
    }
}
