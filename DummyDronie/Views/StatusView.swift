//
//  StatusView.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import SwiftUI

class Status: ObservableObject {
    @Published var battery: Int = 100
    @Published var distance: Double = 0.0
    @Published var altitude: Double = 0.0
}

struct StatusView: View {
    
    @ObservedObject var status: Status
    
    var batteryImage: Image {
        switch status.battery {
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
                Text("\(status.battery)%")
            }
            Text("D \(status.distance, specifier: "%.0f") m")
            Text("Alt \(status.altitude, specifier : "%.0f") m")
        }
        .bold()
    }
}

