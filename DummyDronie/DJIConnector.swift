//
//  DJIConnector.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import Foundation
import DJISDK

class DJIConnector: NSObject, DJISDKManagerDelegate, DJIAppActivationManagerDelegate, ObservableObject {
    
    @Published private(set) var isDroneConnected: Bool = false
    
    func registerWithSDK() {
        let appKey = Bundle.main.object(forInfoDictionaryKey: SDK_APP_KEY_INFO_PLIST_KEY) as? String
        
        guard appKey != nil && appKey!.isEmpty == false else {
            log.error("Please enter your app key in the info.plist")
            return
        }
        log.info("Trying to register DJI SDK manager")
        DispatchQueue.global(qos: .userInitiated).async {
            DJISDKManager.registerApp(with: self)
        }
    }
    
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        log.info("SDK is downloading DB file \(progress.completedUnitCount / progress.totalUnitCount)")
    }
    
    func appRegisteredWithError(_ error: Error?) {
        if let error = error {
            log.error("SDK registered with an error: \(error.localizedDescription)")
            return
        }
        log.info("Successfully registered the DJI SDK manager")
        log.info("Trying to connect to DJI drone")
        DJISDKManager.startConnectionToProduct()
    }
    
    func productConnected(_ product: DJIBaseProduct?) {
        guard let product = product else {
            log.error("DJI product is not found")
            return
        }
        
        if product.model != "Only RemoteController" {
            isDroneConnected = true
        }
        log.info("DJI product connected: \(product.model ?? "unknown")")
    }
    
    func productChanged(_ product: DJIBaseProduct?) {
        guard let product = product else {
            log.error("DJI product is not found")
            return
        }
        if product.model != "Only RemoteController" {
            isDroneConnected = true
        }
        log.info("DJI product connected: \(product.model ?? "unknown")")
    }
    
    func productDisconnected() {
        log.info("DJI drone disconnected")
        isDroneConnected = false
    }
    
}
