//
//  SettingsView.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import SwiftUI

let COUNTDOWN_DURATION_KEY = "countdownDuration"

struct SettingsView: View {
    
    var body: some View {
        VStack {
            Text("Countdown Duration")
                .font(.headline)

            Slider(value: Binding(
                get: { Double(SettingsView.loadCountdownDuration()) },
                set: { SettingsView.saveCountdownDuration(Int($0)) }
            ), in: 1...10, step: 1
            ).padding()

        }
    }
    
    static func saveCountdownDuration(_ duration: Int) {
        UserDefaults.standard.set(duration, forKey: COUNTDOWN_DURATION_KEY)
    }

    static func loadCountdownDuration() -> Int {
        var duration = UserDefaults.standard.integer(forKey: COUNTDOWN_DURATION_KEY)
        if duration == 0 { // Set default duration
            duration = 3
            saveCountdownDuration(3)
        }
        return duration
    }
}
