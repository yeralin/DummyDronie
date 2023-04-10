//
//  DummyDronieApp.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 3/15/23.
//

import SwiftUI
import SwiftyBeaver
let log = SwiftyBeaver.self

@main
struct DummyDronieApp: App {
    
    @StateObject var djiConnector = DJIConnector()
    
    var body: some Scene {
        WindowGroup {
            MainView(djiConnector: djiConnector).onAppear() {
                UIApplication.shared.isIdleTimerDisabled = true
                let console = ConsoleDestination()
                log.addDestination(console)
                djiConnector.registerWithSDK()
            }
        }
    }
    
}
