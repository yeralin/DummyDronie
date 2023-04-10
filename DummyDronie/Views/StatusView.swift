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
    @State private var flashAnimation = false
    
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
            if cameraController.isRecording {
                Image(systemName: "circle.fill")
                    .foregroundColor(.red)
                    .opacity(flashAnimation ? 0 : 1)
                    .onAppear {
                        DispatchQueue.main.async {
                            withAnimation(.linear(duration: 0.5).repeatForever()) {
                                flashAnimation.toggle()
                            }
                        }
                    }
            }
        }
        .bold()
    }
}
