//
//  DroneController.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/8/23.
//

import Foundation
import UIKit
import DJISDK


class VideoPreviewController: NSObject, DJIVideoFeedListener, ObservableObject {
    
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
    }

    func resetVideoPreviewer() {
        guard let videoPreviewer = DJIVideoPreviewer.instance() else {
            log.error("Could not fetch DJIVideoPreviewer instance")
            return
        }
        guard let videoFeeder = DJISDKManager.videoFeeder() else {
            log.error("Could not fetch the video feeder instance")
            return
        }
        videoPreviewer.unSetView()
        videoFeeder.primaryVideoFeed.remove(self)
        log.info("Reset video previewer")
    }

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
