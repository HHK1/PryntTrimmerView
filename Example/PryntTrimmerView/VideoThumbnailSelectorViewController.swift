//
//  VideoThumbnailSelectorViewController.swift
//  PryntTrimmerView
//
//  Created by Henry on 06/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Photos
import PryntTrimmerView
import AVFoundation

class VideoThumbnailSelectorViewController: UIViewController {
 
    @IBOutlet weak var playerView: VideoCropView!
    @IBOutlet weak var selectThumbView: ThumbSelectorView!
    var fetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: .video, options: nil)
    
    @IBAction func selectAsset(_ sender: Any) {
        let randomAssetIndex = Int(arc4random_uniform(UInt32(fetchResult.count - 1)))
        let asset = fetchResult.object(at: randomAssetIndex)
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (avAsset, audioMix, info) in
            DispatchQueue.main.async {
                if let avAsset = avAsset {
                    self.loadAsset(avAsset)
                }
            }
        }
    }
    
    func loadAsset(_ asset: AVAsset) {
        
        selectThumbView.asset = asset
        selectThumbView.delegate = self
        playerView.asset = asset
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { 
            self.playerView.updateCropView()
        }
    }
}

extension VideoThumbnailSelectorViewController: ThumbSelectorViewDelegate {
    
    func didChangeThumbPosition(_ imageTime: CMTime) {
        playerView.player?.seek(to: imageTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
}
