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
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let cropBoxView = UIView()
    
    var asset: AVAsset? {
        didSet {
            if let asset = asset {
                setupVideo(with: asset)
            }
        }
    }
    
    var assetSize: CGSize {
        guard let track = asset?.tracks(withMediaType: AVMediaTypeVideo).first else { return CGSize.zero }
        let trackSize = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: fabs(trackSize.width), height: fabs(trackSize.height))
    }
    
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
        contentView.backgroundColor = .yellow
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    }
    
    private func setupVideo(with asset: AVAsset) {
        
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = CGRect(x: 0, y: 0, width: assetSize.width, height: assetSize.height)
        playerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        contentView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        contentView.layer.addSublayer(playerLayer!)
        scrollView.contentSize = assetSize
        setZoomScale(assetSize: assetSize)
        
        print("content view bounds \(contentView.bounds)")
        print("player size \(playerLayer!.frame)")
        print("content size \(scrollView.contentSize)")
        print("scroll view size \(scrollView.bounds)")
        print("content view layer size \(contentView.layer.bounds)")
    }
    
    func setZoomScale(assetSize: CGSize) {
        
        let scale = min(bounds.width / assetSize.width, bounds.height / assetSize.height)
        scrollView.minimumZoomScale = scale
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = scale
        
        print("asset size \(assetSize)")
        print("bounds \(bounds)")
        print("scale \(scale)")
    }
}

extension VideoCropView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        scrollView.contentSize = CGSize(width: assetSize.width * scale, height: assetSize.height * scale)
    }
}
