//
//  SettingsView.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import SwiftUI


class Settings {
    
    enum Setting: String {
        case countdownDurationKey
        case rollVelocityKey
        case throttleVelocityKey
        
        var defaultValue: Double {
            switch self {
                case .countdownDurationKey:
                    return 3 // secs
                case .rollVelocityKey:
                    return 3 // m/s
                case .throttleVelocityKey:
                    return 1 // m/s
            }
        }
    }
    
    static func loadSetting(_ setting: Setting) -> Double {
        let loadedValue = UserDefaults.standard.double(forKey: setting.rawValue)
        if loadedValue == 0 { // Set default value
            saveSetting(setting, value: setting.defaultValue)
            return setting.defaultValue
        }
        return loadedValue
    }
    
    static func saveSetting(_ setting: Setting, value: Double) {
        UserDefaults.standard.set(value, forKey: setting.rawValue)
    }
    
}

struct SettingsView: View {
    
    @State private var countdownDuration = Settings.loadSetting(.countdownDurationKey)
    @State private var rollVelocity = Settings.loadSetting(.rollVelocityKey)
    @State private var throttleVelocity = Settings.loadSetting(.throttleVelocityKey)
    
    var body: some View {
        VStack {
            VStack {
                Text("Countdown Duration").font(.title3)
                HStack {
                    Slider(value: $countdownDuration, in: 1...10, step: 1, onEditingChanged: { _ in
                        Settings.saveSetting(.countdownDurationKey, value: countdownDuration)
                    })
                    Text("\(Int(countdownDuration)) secs")
                }
            }
            VStack {
                Text("Roll (backward) velocity").font(.title3)
                HStack {
                    Slider(value: $rollVelocity, in: 0...15, step: 1, onEditingChanged: { _ in
                        Settings.saveSetting(.rollVelocityKey, value: rollVelocity)
                    })
                    Text("\(Int(rollVelocity)) m/s")
                }
            }
            VStack {
                Text("Throttle (lift) velocity").font(.title3)
                HStack {
                    Slider(value: $throttleVelocity, in: 0...15, step: 1, onEditingChanged: { _ in
                        Settings.saveSetting(.throttleVelocityKey, value: throttleVelocity)
                    })
                    Text("\(Int(throttleVelocity)) m/s")
                }
            }
        }
    }
    

}
