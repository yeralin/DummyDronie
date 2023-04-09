//
//  FPVView.swift
//  DummyDronie
//
//  Created by Yeralin, Daniyar on 4/9/23.
//

import SwiftUI

struct FPVView: UIViewRepresentable {
    
    @ObservedObject var videoPreviewController: VideoPreviewController

    func makeUIView(context: Context) -> UIView {
        let fpvPreview = UIView.init()
        fpvPreview.backgroundColor = UIColor(.gray)
        return fpvPreview
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        videoPreviewController.setupVideoPreviewer(fpvPreview: uiView)
    }

    func dismantleUIView(_ uiView: UIView, coordinator: ()) {
        videoPreviewController.resetVideoPreviewer()
    }
}
