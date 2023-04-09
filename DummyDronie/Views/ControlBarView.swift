//
//  ControlBarView.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import SwiftUI

struct ControlBarView: View {
    @State private var countdownDuration = SettingsView.loadCountdownDuration()
    
    @State private var countdown = 0
    @State private var isRecording = false
    @State private var isConnected = false
    
    @Binding var flightController: FlightController
    @Binding var showSettings: Bool
    
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
                if !isRecording {
                    startCountdown {
                        isRecording = true
                    }
                }
            }) {
                if countdown > 0 {
                    Text("\(countdown)")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                } else {
                    Image(systemName: isRecording ? "record.circle.fill" : "record.circle")
                        .foregroundColor(isRecording ? .red :  .blue)
                        .font(.system(size: 50))
                        .frame(width: 30, height: 30)
                }
            }.disabled(countdown > 0)
            Spacer()
            Image(systemName: isConnected ? "wifi" : "wifi.slash")
                .foregroundColor(isConnected ? .green : .red)
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
