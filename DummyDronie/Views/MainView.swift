//
//  ContentView.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 3/15/23.
//

import SwiftUI

struct MainView: View {
    
    @State private var videoPreviewController = VideoPreviewController()
    @State private var flightController = FlightController()
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                FPVView(videoPreviewController: $videoPreviewController)
                    .edgesIgnoringSafeArea(.all)
                HStack {
                    Spacer()
                    ControlBarView(flightController: $flightController,
                                   showSettings: $showSettings)
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
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
