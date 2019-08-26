//
//  MainTrimmerView.swift
//  PryntTrimmerView
//
//  Created by Cosmin Pahomi on 05/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation

public class MainTrimmerView: UIView {

    private lazy var trimmerView: TrimmerView = {
        let trimmer = TrimmerView(frame: CGRect.zero)
        trimmer.translatesAutoresizingMaskIntoConstraints = false
        trimmer.scrollDelegate = self
        addSubview(trimmer)
        return trimmer
    }()

    private lazy var timestampScroll: TimestampScrollView = {
        let timestamp = TimestampScrollView(frame: CGRect.zero)
        timestamp.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timestamp)

        return timestamp
    }()

    public var asset: AVAsset? {
        didSet {

            guard let a = asset else {
                return
            }
            
            trimmerView.asset = asset

            let duration = CGFloat(CMTimeGetSeconds(a.duration))
            timestampScroll.addDotsWithLabelsFor(duration, withContentsSize: trimmerView.assetPreview.contentSize)
        }
    }

    public weak var delegate: TrimmerViewDelegate? {
        didSet {
            trimmerView.delegate = delegate
        }
    }

    // MARK: - Initialization
    override public func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false

        setup()
        setupConstraints()
    }

    // MARK: - Setup
    public func setup() {
        clipsToBounds = true
        self.timestampScroll.delegate = self
    }

    public func setupConstraints() {
        trimmerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        trimmerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        trimmerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        trimmerView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        timestampScroll.leadingAnchor.constraint(equalTo: leadingAnchor, constant: trimmerView.handleWidth).isActive = true
        timestampScroll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trimmerView.handleWidth).isActive = true
        timestampScroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        timestampScroll.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    // MARK: - Video Methods
    public func seek(to time: CMTime) {
        trimmerView.seek(to: time)
    }
    
    public func startTime() -> CMTime? {
        return trimmerView.startTime
    }
    
    public func endTime() -> CMTime? {
        return trimmerView.endTime
    }

}

extension MainTrimmerView: TrimmerScrollDelegate {
    public func scrollDidMove(_ contentOffset: CGPoint) {
        timestampScroll.contentOffset = contentOffset
    }
}

extension MainTrimmerView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.trimmerView.assetPreview.contentOffset = scrollView.contentOffset
    }
}
