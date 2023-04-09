//
//  DJIConnector.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import Foundation
import DJISDK

class DJIConnector: NSObject, DJISDKManagerDelegate, ObservableObject {
    
    func registerWithSDK() {
        let appKey = Bundle.main.object(forInfoDictionaryKey: SDK_APP_KEY_INFO_PLIST_KEY) as? String
        
        guard appKey != nil && appKey!.isEmpty == false else {
            log.error("Please enter your app key in the info.plist")
            return
        }
        
        DJISDKManager.registerApp(with: self)
    }
    
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        log.info("SDK is downloading DB file \(progress.completedUnitCount / progress.totalUnitCount)")
    }
    
    func appRegisteredWithError(_ error: Error?) {
        log.error("SDK registered with an error: \(error?.localizedDescription ?? "Unknown")")
        DJISDKManager.startConnectionToProduct()
    }
    
}
