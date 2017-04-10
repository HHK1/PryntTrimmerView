//
//  VideoCropView.swift
//  PryntTrimmerView
//
//  Created by Henry on 07/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCropView: UIView {
    
    let videoScrollView = VideoScrollView()
    let cropMaskView = CropMaskView()
    
    var asset: AVAsset? {
        didSet {
           videoScrollView.asset = asset
        }
    }
    
    var player: AVPlayer? {
        return videoScrollView.player
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        videoScrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(videoScrollView)
        
        videoScrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        videoScrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        videoScrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoScrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        cropMaskView.isUserInteractionEnabled = false
        cropMaskView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cropMaskView)
        
        cropMaskView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cropMaskView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cropMaskView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cropMaskView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        cropMaskView.cropFrame = CGRect(x: 10, y: 10, width: 140, height: 250)
    }
}
