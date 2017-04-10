//
//  VideoScrollView.swift
//  PryntTrimmerView
//
//  Created by Henry on 10/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation

class VideoScrollView: UIView {
    
    let scrollView = UIScrollView()
    var contentView = UIView()
    
    var asset: AVAsset? {
        didSet {
            if let asset = asset {
                setupVideo(with: asset)
            }
        }
    }
    
    var assetSize = CGSize.zero
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .red
        scrollView.addSubview(contentView)
        scrollView.delegate = self
        addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    private func setupVideo(with asset: AVAsset) {
        
        guard let track = asset.tracks(withMediaType: AVMediaTypeVideo).first else { return }
        let trackSize = track.naturalSize.applying(track.preferredTransform)
        assetSize = CGSize(width: fabs(trackSize.width), height: fabs(trackSize.height))
        
        playerLayer?.removeFromSuperlayer()
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        scrollView.zoomScale = 1.0
        
        let playerFrame = CGRect(x: 0, y: 0, width: assetSize.width, height: assetSize.height)
        playerLayer?.removeFromSuperlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = playerFrame
        playerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        contentView.frame = playerFrame
        contentView.layer.addSublayer(playerLayer!)
        
        scrollView.contentSize = assetSize
        setZoomScale()
        centerContent(for: scrollView.zoomScale)
        print("content view bounds \(contentView.bounds)")
        print("player size \(playerLayer!.frame)")
        print("content size \(scrollView.contentSize)")
        print("scroll view size \(scrollView.bounds)")
        print("content view layer size \(contentView.layer.bounds)")
    }
    
    func setZoomScale() {
        
        let scale = min(bounds.width / assetSize.width, bounds.height / assetSize.height)
        scrollView.minimumZoomScale = scale
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = scale
    }
    
    func centerContent(for scale: CGFloat) {
        
        
    }
}

extension VideoScrollView: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        let scaledAssetSize = CGSize(width: assetSize.width * scale, height: assetSize.height * scale)
        scrollView.contentSize = scaledAssetSize
    }
}
