//
//  AVAssetTimeSelector.swift
//  Pods
//
//  Created by Henry on 06/04/2017.
//
//

import UIKit
import AVFoundation

public protocol AVAssetTimeSelectorDelegate: class {
    func thumbnailFor(_ imageTime: CMTime, completion: @escaping (UIImage?)->())
}

/// A generic class to display an asset into a scroll view with thumbnail images, and make the equivalence between a time in
// the asset and a position in the scroll view
public class AVAssetTimeSelector: UIView, UIScrollViewDelegate {

    public weak var delegate: AVAssetTimeSelectorDelegate?

    let assetPreview = AssetVideoScrollView()
    
    public var rideDuration: Double? {
        didSet {
            propertiesDidChange()
        }
    }
    
    public var thumbnailFrameAspectRatio: CGFloat? {
        didSet {
            propertiesDidChange()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    func setupSubviews() {
        setupAssetPreview()
        constrainAssetPreview()
    }

    // MARK: - Asset Preview

    func setupAssetPreview() {
        assetPreview.translatesAutoresizingMaskIntoConstraints = false
        assetPreview.delegate = self
        assetPreview.framesDelegate = self
        addSubview(assetPreview)
    }

    func constrainAssetPreview() {
        assetPreview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        assetPreview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        assetPreview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        assetPreview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func propertiesDidChange() {
        guard let rideDuration = rideDuration, let thumbnailFrameAspectRatio = thumbnailFrameAspectRatio else {
            return
        }
        
        assetPreview.recalculateThumbnailTimes(for: rideDuration, thumbnailFrameAspectRatio: thumbnailFrameAspectRatio)
    }

    // MARK: - Time & Position Equivalence

    var durationSize: CGFloat {
        return assetPreview.contentSize.width
    }

    func getTime(from position: CGFloat) -> CMTime? {
        guard let rideDuration = rideDuration else {
            return nil
        }
        let normalizedRatio = max(min(1, position / durationSize), 0)
        let positionTimeValue = Double(normalizedRatio) * Double(rideDuration)
        return CMTime(value: Int64(positionTimeValue), timescale: 1)
    }

    func getPosition(from time: CMTime) -> CGFloat? {
        guard let duration = rideDuration else {
            return nil
        }
        let timeRatio = CGFloat(time.value) / CGFloat(duration)
        return timeRatio * durationSize
    }
}

extension AVAssetTimeSelector: AssetVideoScrollViewDelegate {
    
    func thumbnailFor(_ imageTime: CMTime, completion: @escaping (UIImage?)->()) {
        delegate?.thumbnailFor(imageTime, completion: completion)
    }
}
