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
    var contentView = UIView()
    let cropBoxView = UIView()
    let frameView = UIView()
    
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
        scrollView.delegate = self
        addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        let view = UIView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        view.backgroundColor = .black
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height), cornerRadius: 0)
        path.lineWidth = 0.0
        let circlePath = UIBezierPath(roundedRect: CGRect(x: 50, y: 16, width: 100, height: 150), cornerRadius: 0)
        circlePath.lineWidth = 4.0
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 1.0
    
        let lineWidth: CGFloat = 3.0
        let framePath = UIBezierPath(roundedRect:CGRect(x: 50, y: 16, width: 100, height: 150), cornerRadius: 0)
        framePath.lineWidth = lineWidth
        let frameLayer = CAShapeLayer()
        frameLayer.path = framePath.cgPath
        frameLayer.strokeColor = UIColor.white.cgColor
        frameLayer.fillColor = UIColor.clear.cgColor
        
        frameView.layer.addSublayer(frameLayer)
        cropBoxView.layer.mask = fillLayer
        cropBoxView.translatesAutoresizingMaskIntoConstraints = false
        cropBoxView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        addSubview(cropBoxView)
        addSubview(frameView)

        cropBoxView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cropBoxView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cropBoxView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cropBoxView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        
    }
    
    func updateCropView() {
        
        if let shapeLayer = cropBoxView.layer.mask as? CAShapeLayer {
            
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height), cornerRadius: 0)
            let circlePath = UIBezierPath(roundedRect: CGRect(x: 50, y: 16, width: 200, height: 100), cornerRadius: 0)
            path.append(circlePath)
            path.usesEvenOddFillRule = true
            
            let animation = CABasicAnimation(keyPath: "path")
            animation.toValue = path.cgPath
            animation.duration = 1
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.fillMode = kCAFillModeBoth
            animation.isRemovedOnCompletion = false
            
            shapeLayer.add(animation, forKey: "path animation")
            animation.toValue = circlePath.cgPath
            
            if let frameLayer = frameView.layer.sublayers?.first as? CAShapeLayer {
                frameLayer.add(animation, forKey: "frame animation")
            }
        }
    }
    
    private func setupVideo(with asset: AVAsset) {
        
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

extension VideoCropView: UIScrollViewDelegate {
    
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
