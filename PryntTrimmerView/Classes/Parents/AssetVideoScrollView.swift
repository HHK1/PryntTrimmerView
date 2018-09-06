//
//  AssetVideoScrollView.swift
//  PryntTrimmerView
//
//  Created by HHK on 28/03/2017.
//  Copyright © 2017 Prynt. All rights reserved.
//

import AVFoundation
import UIKit

protocol AssetVideoScrollViewDelegate: class {
    func thumbnailFor(_ imageTime: CMTime, completion: @escaping (UIImage?)->())
}

class AssetVideoScrollView: UIScrollView {

    public weak var framesDelegate: AssetVideoScrollViewDelegate?
    
    private var widthConstraint: NSLayoutConstraint?

    let contentView = UIView()
    var maxDuration: Double = 15
    private var thumbnailFrameAspectRatio: CGFloat?
    private var duration: TimeInterval?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    private func setupSubviews() {
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        clipsToBounds = true

        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.tag = -1
        addSubview(contentView)

        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        widthConstraint = contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0)
        widthConstraint?.isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentSize = contentView.bounds.size
        guard let duration = duration, let thumbnailFrameAspectRatio = thumbnailFrameAspectRatio else {
            return
        }
        recalculateThumbnailTimes(for: duration, thumbnailFrameAspectRatio: thumbnailFrameAspectRatio)
    }

    internal func recalculateThumbnailTimes(for duration: TimeInterval, thumbnailFrameAspectRatio: CGFloat) {
        guard
            let thumbnailSize = getThumbnailFrameSize(for: thumbnailFrameAspectRatio),
            thumbnailSize.height.isNormal,
            thumbnailSize.width.isNormal else {
            return
        }
        
        self.thumbnailFrameAspectRatio = thumbnailFrameAspectRatio
        self.duration = duration
        
        removeFormerThumbnails()
        let newContentSize = frame.size  // setContentSize(for: asset)
        let visibleThumbnailsCount = Int(ceil(frame.width / thumbnailSize.width))
        let thumbnailCount =  thumbnailSize.width > 0 ? Int(ceil(newContentSize.width / thumbnailSize.width)) : 0
        addThumbnailViews(thumbnailCount, size: thumbnailSize)
        let thumbnailTimes = getThumbnailTimes(for: duration, numberOfThumbnails: thumbnailCount)
        generateImages(at: thumbnailTimes, with: thumbnailSize, visibleThumnails: thumbnailCount)
    }

    private func getThumbnailFrameSize(for aspectRatio: CGFloat) -> CGSize? {
        let height = frame.height
        let width = height * aspectRatio
        return CGSize(width: fabs(width), height: fabs(height))
    }

    private func removeFormerThumbnails() {
        contentView.subviews.forEach({ $0.removeFromSuperview() })
    }

    private func setContentSize(for asset: AVAsset) -> CGSize {
        let contentWidthFactor = CGFloat(max(1, asset.duration.seconds / maxDuration))
        widthConstraint?.isActive = false
        widthConstraint = contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: contentWidthFactor)
        widthConstraint?.isActive = true
        layoutIfNeeded()
        return contentView.bounds.size
    }

    private func addThumbnailViews(_ count: Int, size: CGSize) {
        for index in 0..<count {

            let thumbnailView = UIImageView(frame: CGRect.zero)
            thumbnailView.clipsToBounds = true

            let viewEndX = CGFloat(index) * size.width + size.width

            if viewEndX > contentView.frame.width {
                thumbnailView.frame.size = CGSize(width: size.width + (contentView.frame.width - viewEndX), height: size.height)
                thumbnailView.contentMode = .scaleAspectFill
            } else {
                thumbnailView.frame.size = size
                thumbnailView.contentMode = .scaleAspectFit
            }

            thumbnailView.frame.origin = CGPoint(x: CGFloat(index) * size.width, y: 0)
            thumbnailView.tag = index
            contentView.addSubview(thumbnailView)
        }
    }

    private func getThumbnailTimes(for duration: TimeInterval, numberOfThumbnails: Int) -> [NSValue] {
        let timeIncrement = (duration * 1000) / Double(numberOfThumbnails)
        var timesForThumbnails = [NSValue]()
        for index in 0..<numberOfThumbnails {
            let cmTime = CMTime(value: Int64(timeIncrement * Float64(index)), timescale: 1000)
            let nsValue = NSValue(time: cmTime)
            timesForThumbnails.append(nsValue)
        }
        return timesForThumbnails
    }

    private func generateImages(at times: [NSValue], with maximumSize: CGSize, visibleThumnails: Int) {
        let scaledSize = CGSize(width: maximumSize.width * UIScreen.main.scale,
                                height: maximumSize.height *  UIScreen.main.scale)
        var count = 0

        for time in times {
            framesDelegate?.thumbnailFor(time.timeValue) { image in
                DispatchQueue.main.async { [weak self] () -> Void in
                    guard let image = image else {
                        return
                    }
                    if count == 0 {
                        self?.displayFirstImage(image, visibleThumbnails: visibleThumnails)
                    }
                    self?.displayImage(image, at: count)
                    count += 1
                }
            }
        }
    }

    private func displayFirstImage(_ image: UIImage, visibleThumbnails: Int) {
        for i in 0...visibleThumbnails {
            displayImage(image, at: i)
        }
    }

    private func displayImage(_ image: UIImage, at index: Int) {
        if let imageView = contentView.viewWithTag(index) as? UIImageView {
            imageView.image = image
        }
    }
}
