//
//  ContentView.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 3/15/23.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var djiConnector: DJIConnector
    @StateObject private var videoPreviewController = VideoPreviewController()
    @StateObject private var flightController = FlightController()
    @StateObject private var cameraController = CameraController()
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                FPVView(djiConnector: djiConnector,
                        videoPreviewController: videoPreviewController)
                    .edgesIgnoringSafeArea(.all)
                HStack {
                    Spacer()
                    ControlBarView(showSettings: $showSettings,
                                   djiConnector: djiConnector,
                                   flightController: flightController,
                                   cameraController: cameraController)
                        .frame(width: 5, alignment: .bottom)
                }
                VStack {
                    Spacer()
                    HStack {
                        StatusView(status: Status())
                        Spacer()
                    }
                }
            }
        }.onAppear() {
            djiConnector.registerWithSDK()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    
    static var djiConnector = DJIConnector()
    
    static var previews: some View {
        MainView(djiConnector: djiConnector)
    }
}

