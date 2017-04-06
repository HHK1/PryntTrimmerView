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
 
    var player: AVPlayer?
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var selectThumbView: ThumbSelectorView!
    
    var fetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: .video, options: nil)

    func addVideoPlayer(with asset: AVAsset, playerView: UIView) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoTrimmerViewController.itemDidFinishPlaying(_:)) , name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: playerView.frame.width, height: playerView.frame.height)
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        playerView.layer.addSublayer(layer)
    }
    
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
        addVideoPlayer(with: asset, playerView: playerView)
    }
}

extension VideoThumbnailSelectorViewController: ThumbSelectorViewDelegate {
    
    func didChangeThumbPosition(_ imageTime: CMTime) {
        player?.seek(to: imageTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
}
