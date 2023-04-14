//
//  ControlBarView.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import SwiftUI

struct ControlBarView: View {
    
    @State private var countdownDuration = SettingsView.loadCountdownDuration()
    @Binding var showSettings: Bool
    
    @State private var countdown = 0
    
    @ObservedObject var djiConnector: DJIConnector
    @ObservedObject var flightController: FlightController
    @ObservedObject var cameraController: CameraController
    
    var body: some View {
        VStack {
            NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                Button(action: {
                    showSettings.toggle()
                }) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.blue)
                        .font(.system(size: 30))
                        .padding(.top)
                }
            }
            Spacer()
            Button(action: {
                if !cameraController.isRecording {
                    startCountdown {
                        cameraController.startVideoRecording()
                        flightController.startVerticalTakeoff()
                    }
                } else {
                    flightController.stopVerticalTakeoff()
                    cameraController.stopVideoRecording()
                }
            }) {
                if countdown > 0 {
                    Text("\(countdown)")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                } else {
                    Image(systemName: cameraController.isRecording ? "record.circle.fill" : "record.circle")
                        .foregroundColor(cameraController.isRecording ? .red :  .blue)
                        .font(.system(size: 60))
                        .frame(width: 30, height: 30)
                }
            }
            .disabled(countdown > 0 || !djiConnector.isDroneConnected)
            .onChange(of: flightController.verticalTakeoffJob?.isValid) { isValid in
                // If the job is invalid, stop recording
                if !(isValid ?? false) {
                    cameraController.stopVideoRecording()
                }
            }
            Spacer()
            Image(systemName: djiConnector.isDroneConnected ? "wifi" : "wifi.slash")
                .foregroundColor(djiConnector.isDroneConnected ? .green : .red)
                .font(.system(size: 30))
                .padding(.bottom)
        }
        .padding(.leading)
        .background(Color.white)
        
    }
    
    private func startCountdown(completion: @escaping () -> Void) {
        countdown = countdownDuration
        guard countdown > 0 else {
            completion()
            return
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            countdown -= 1
            if countdown <= 0 {
                timer.invalidate()
                completion()
            }
        }
    }
    
}
