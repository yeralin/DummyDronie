//
//  DroneController.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/8/23.
//

import Foundation
import UIKit
import DJISDK

/// VideoPreviewController handles the video preview setup and teardown for DJI drone's camera feed.
class VideoPreviewController: NSObject, DJIVideoFeedListener, ObservableObject {
    
    /// A boolean property to indicate if the view preview is set up.
    var isViewPreviewSetup: Bool = false
    
    /// Sets up the video previewer for the DJI drone's camera feed.
    /// - Parameter fpvPreview: The UIView to display the video preview.
    func setupVideoPreviewer(fpvPreview: UIView) {
        guard let videoPreviewer = DJIVideoPreviewer.instance() else {
            log.error("Could not fetch DJIVideoPreviewer instance")
            return
        }
        guard let videoFeeder = DJISDKManager.videoFeeder() else {
            log.error("Could not fetch the video feeder instance")
            return
        }
        videoPreviewer.setView(fpvPreview)
        videoFeeder.primaryVideoFeed.add(self, with: nil)
        videoPreviewer.start()
        log.info("Setup video previewer")
        isViewPreviewSetup = true
    }
    
    /// Resets the video previewer and removes it from the DJI drone's camera feed.
    func resetVideoPreviewer() {
        guard let videoPreviewer = DJIVideoPreviewer.instance() else {
            log.error("Could not fetch DJIVideoPreviewer instance")
            return
        }
        guard let videoFeeder = DJISDKManager.videoFeeder() else {
            log.error("Could not fetch the video feeder instance")
            return
        }
        videoFeeder.primaryVideoFeed.remove(self)
        videoPreviewer.unSetView()
        log.info("Reset video previewer")
        isViewPreviewSetup = false
    }
    
    /// Processes the updated video data from the DJI drone's camera feed.
    @objc func videoFeed(_ videoFeed: DJIVideoFeed, didUpdateVideoData videoData: Data) {
        guard let videoPreviewer = DJIVideoPreviewer.instance() else {
            log.error("Could not fetch DJIVideoPreviewer instance")
            return
        }
        let nsVideoData = videoData as NSData
        let videoBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: nsVideoData.length)
        nsVideoData.getBytes(videoBuffer, length: nsVideoData.length)
        videoPreviewer.push(videoBuffer, length: Int32(nsVideoData.length))
    }
    
}
