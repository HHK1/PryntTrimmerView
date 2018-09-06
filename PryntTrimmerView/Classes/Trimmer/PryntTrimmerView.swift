//
//  PryntTrimmerView.swift
//  PryntTrimmerView
//
//  Created by HHK on 27/03/2017.
//  Copyright © 2017 Prynt. All rights reserved.
//

import AVFoundation
import UIKit

/// A delegate to be notified of when the thumb position has changed. Useful to link an instance of the ThumbSelectorView to a
/// video preview like an `AVPlayer`.
public protocol TrimmerViewDelegate: AVAssetTimeSelectorDelegate {
    func didChangePositionBar(triggeredHandle: TrimmerView.TriggeredHandle)
    func positionBarStoppedMoving(triggeredHandle: TrimmerView.TriggeredHandle)
}

/// A view to select a specific time range of a video. It consists of an asset preview with thumbnails inside a scroll view, two
/// handles on the side to select the beginning and the end of the range, and a position bar to synchronize the control with a
/// video preview, typically with an `AVPlayer`.
/// Load the video by setting the `asset` property. Access the `startTime` and `endTime` of the view to get the selected time
// range
@IBDesignable public class TrimmerView: AVAssetTimeSelector {

    public enum TriggeredHandle {
        case left
        case right
        case unknown
    }
    
    // MARK: - Properties
    
    private var trimmerDelegate: TrimmerViewDelegate? {
        return delegate as? TrimmerViewDelegate
    }

    // MARK: Color Customization

    /// The color of the main border of the view
    @IBInspectable public var mainColor: UIColor = UIColor.orange {
        didSet {
            updateMainColor()
        }
    }

    /// The color of the handles on the side of the view
    @IBInspectable public var handleColor: UIColor = UIColor.gray {
        didSet {
           updateHandleColor()
        }
    }
    
    // labels for the handlers
    public var rightHandleLabel = UILabel()
    public var leftHandleLabel  = UILabel()

    // MARK: Subviews

    private let trimView = UIView()
    private let leftHandleView = HandlerView()
    private let rightHandleView = HandlerView()
    private let leftHandleKnob = UIView()
    private let rightHandleKnob = UIView()
    private let leftMaskView = UIView()
    private let rightMaskView = UIView()

    // MARK: Constraints

    private var currentLeftConstraint: CGFloat = 0
    private var currentRightConstraint: CGFloat = 0
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    private var positionConstraint: NSLayoutConstraint?

    private let handleWidth: CGFloat = 15

    /// The maximum duration allowed for the trimming. Change it before setting the asset, as the asset preview
    public var maxDuration: Double = 15 {
        didSet {
            assetPreview.maxDuration = maxDuration
        }
    }

    /// The minimum duration allowed for the trimming. The handles won't pan further if the minimum duration is attained.
    public var minDuration: Double = 3
        
    // MARK: - View & constraints configurations

    override func setupSubviews() {

        super.setupSubviews()
        backgroundColor = UIColor.clear
        layer.zPosition = 1
        setupTrimmerView()
        setupHandleView()
        setupMaskView()
        setupGestures()
        updateMainColor()
        updateHandleColor()
    }
    
    open func initializeHandles() {
        leftConstraint?.constant = 0.0
        rightConstraint?.constant = min(2 * handleWidth - frame.width + leftHandleView.frame.origin.x + minimumDistanceBetweenHandle, 0)
        layoutSubviews()
        fixHandlesLabelsPositionIfNeeded()
        layoutSubviews()
    }

    override func constrainAssetPreview() {
        assetPreview.leftAnchor.constraint(equalTo: leftAnchor, constant: handleWidth).isActive = true
        assetPreview.rightAnchor.constraint(equalTo: rightAnchor, constant: -handleWidth).isActive = true
        assetPreview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        assetPreview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    private func setupTrimmerView() {
        trimView.layer.borderWidth = 2.0
        trimView.layer.cornerRadius = 2.0
        trimView.translatesAutoresizingMaskIntoConstraints = false
        trimView.isUserInteractionEnabled = true
        addSubview(trimView)

        trimView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        trimView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        leftConstraint = trimView.leftAnchor.constraint(equalTo: leftAnchor)
        rightConstraint = trimView.rightAnchor.constraint(equalTo: rightAnchor)
        leftConstraint?.isActive = true
        rightConstraint?.isActive = true
    }

    private func setupHandleView() {
        
        leftHandleView.isUserInteractionEnabled = true
        leftHandleView.layer.cornerRadius = 2.0
        leftHandleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftHandleView)

        leftHandleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        leftHandleView.widthAnchor.constraint(equalToConstant: handleWidth).isActive = true
        leftHandleView.leftAnchor.constraint(equalTo: trimView.leftAnchor).isActive = true
        leftHandleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        leftHandleKnob.translatesAutoresizingMaskIntoConstraints = false
        leftHandleView.addSubview(leftHandleKnob)
        
        leftHandleLabel.layer.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8).cgColor
        leftHandleLabel.textColor = UIColor.white
        leftHandleLabel.textAlignment = .center
        leftHandleLabel.text = "00:00:00 AM"
        leftHandleLabel.frame = CGRect(x: -60, y: -40, width: 120.0, height: 30.0)
        leftHandleLabel.layer.cornerRadius = 5.0
        leftHandleView.addSubview(leftHandleLabel)

        leftHandleKnob.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        leftHandleKnob.widthAnchor.constraint(equalToConstant: 2).isActive = true
        leftHandleKnob.centerYAnchor.constraint(equalTo: leftHandleView.centerYAnchor).isActive = true
        leftHandleKnob.centerXAnchor.constraint(equalTo: leftHandleView.centerXAnchor).isActive = true

        rightHandleView.isUserInteractionEnabled = true
        rightHandleView.layer.cornerRadius = 2.0
        rightHandleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightHandleView)

        rightHandleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        rightHandleView.widthAnchor.constraint(equalToConstant: handleWidth).isActive = true
        rightHandleView.rightAnchor.constraint(equalTo: trimView.rightAnchor).isActive = true
        rightHandleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        rightHandleKnob.translatesAutoresizingMaskIntoConstraints = false
        rightHandleView.addSubview(rightHandleKnob)
        
        rightHandleLabel.layer.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8).cgColor
        rightHandleLabel.textColor = UIColor.white
        rightHandleLabel.textAlignment = .center
        rightHandleLabel.text = "00:00:00 AM"
        rightHandleLabel.frame = CGRect(x: -60, y: -40, width: 120.0, height: 30.0)
        rightHandleLabel.layer.cornerRadius = 5.0
        rightHandleView.addSubview(rightHandleLabel)

        rightHandleKnob.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        rightHandleKnob.widthAnchor.constraint(equalToConstant: 2).isActive = true
        rightHandleKnob.centerYAnchor.constraint(equalTo: rightHandleView.centerYAnchor).isActive = true
        rightHandleKnob.centerXAnchor.constraint(equalTo: rightHandleView.centerXAnchor).isActive = true
    }

    private func setupMaskView() {

        leftMaskView.isUserInteractionEnabled = false
        leftMaskView.backgroundColor = .white
        leftMaskView.alpha = 0.7
        leftMaskView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(leftMaskView, belowSubview: leftHandleView)

        leftMaskView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        leftMaskView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        leftMaskView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftMaskView.rightAnchor.constraint(equalTo: leftHandleView.centerXAnchor).isActive = true

        rightMaskView.isUserInteractionEnabled = false
        rightMaskView.backgroundColor = .white
        rightMaskView.alpha = 0.7
        rightMaskView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(rightMaskView, belowSubview: rightHandleView)

        rightMaskView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rightMaskView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rightMaskView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rightMaskView.leftAnchor.constraint(equalTo: rightHandleView.centerXAnchor).isActive = true
    }

    private func setupGestures() {
        let trimViewGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(TrimmerView.handlePanGesture))
        trimView.addGestureRecognizer(trimViewGestureRecognizer)
        let leftPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(TrimmerView.handlePanGesture))
        leftHandleView.addGestureRecognizer(leftPanGestureRecognizer)
        let rightPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(TrimmerView.handlePanGesture))
        rightHandleView.addGestureRecognizer(rightPanGestureRecognizer)
    }

    private func updateMainColor() {
        trimView.layer.borderColor = mainColor.cgColor
        leftHandleView.backgroundColor = mainColor
        rightHandleView.backgroundColor = mainColor
    }

    private func updateHandleColor() {
        leftHandleKnob.backgroundColor = handleColor
        rightHandleKnob.backgroundColor = handleColor
    }

    // MARK: - Trim Gestures

    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view, let superView = gestureRecognizer.view?.superview else { return }
        let triggeredHandle: TriggeredHandle = view == leftHandleView ? .left : view == rightHandleView ? .right : .unknown
        switch gestureRecognizer.state {

        case .began:
            if view == leftHandleView {
                currentLeftConstraint = leftConstraint!.constant
                self.bringSubview(toFront: leftHandleView)
            } else if view == rightHandleView {
                currentRightConstraint = rightConstraint!.constant
                self.bringSubview(toFront: rightHandleView)
            } else {
                currentLeftConstraint = leftConstraint!.constant
                currentRightConstraint = rightConstraint!.constant
            }
            updateSelectedTime(stoppedMoving: false, triggeredHandle: triggeredHandle)
        case .changed:
            let translation = gestureRecognizer.translation(in: superView)
            if view == leftHandleView {
                updateLeftConstraint(with: translation)
            } else if view == rightHandleView {
                updateRightConstraint(with: translation)
            } else {
                updateLeftConstraint(with: translation)
                updateRightConstraint(with: translation)
            }
            fixHandlesLabelsPositionIfNeeded()
            if let startTime = startTime, view == leftHandleView {
                seek(to: startTime)
            } else if let endTime = endTime {
                seek(to: endTime)
            }
            updateSelectedTime(stoppedMoving: false, triggeredHandle: triggeredHandle)

        case .cancelled, .ended, .failed:
            updateSelectedTime(stoppedMoving: true, triggeredHandle: triggeredHandle)
        default: break
        }
    }

    private func updateLeftConstraint(with translation: CGPoint) {
        let maxConstraint = max(rightHandleView.frame.origin.x - handleWidth - minimumDistanceBetweenHandle, 0)
        let minConstraint = max(rightHandleView.frame.origin.x - handleWidth - maximumDistanceBetweenHandle, 0)
        var newConstraint = min(max(0, currentLeftConstraint + translation.x), maxConstraint)
        if newConstraint < minConstraint {
            newConstraint = minConstraint
        }
        leftConstraint?.constant = newConstraint
    }

    private func updateRightConstraint(with translation: CGPoint) {
        let maxConstraint = min(2 * handleWidth - frame.width + leftHandleView.frame.origin.x + minimumDistanceBetweenHandle, 0)
        let minConstraint = min(2 * handleWidth - frame.width + leftHandleView.frame.origin.x + maximumDistanceBetweenHandle, 0)
        var newConstraint = max(min(0, currentRightConstraint + translation.x), maxConstraint)
        if newConstraint > minConstraint {
            newConstraint = minConstraint
        }
        rightConstraint?.constant = newConstraint
    }
    
    private func fixHandlesLabelsPositionIfNeeded() {
        let leftOffset = leftHandleView.frame.minX - leftHandleLabel.frame.width / 2
        var leftMove = CGFloat(0.0), rightMove = CGFloat(0.0)
        if leftOffset < 0 {
            leftHandleLabel.frame = CGRect(x: -60 - leftOffset, y: -40, width: 120.0, height: 30.0)
            leftMove = leftOffset
        } else {
            leftHandleLabel.frame = CGRect(x: -60, y: -40, width: 120.0, height: 30.0)
        }
        let rightOffset = frame.width + handleWidth - rightHandleView.frame.maxX - rightHandleLabel.frame.width / 2
        if rightOffset < 0 {
            rightHandleLabel.frame = CGRect(x: -60 + rightOffset, y: -40, width: 120.0, height: 30.0)
            rightMove = rightOffset
        } else {
            rightHandleLabel.frame = CGRect(x: -60, y: -40, width: 120.0, height: 30.0)
        }
        let overlap = rightHandleView.center.x - leftHandleView.center.x - leftHandleLabel.frame.width + rightMove + leftMove
        if overlap < 6 {
            if leftMove < 0 {
                rightHandleLabel.frame = CGRect(x: -60 + 6 - overlap, y: -40, width: 120.0, height: 30.0)
            }
            if rightMove < 0 {
                leftHandleLabel.frame = CGRect(x: -60 - 6 + overlap, y: -40, width: 120.0, height: 30.0)
            }
            if leftMove == 0 && rightMove == 0 {
                let overlapOffset = abs(overlap / 2) + 3
                rightHandleLabel.frame = CGRect(x: -60 + overlapOffset, y: -40, width: 120.0, height: 30.0)
                leftHandleLabel.frame = CGRect(x: -60 - overlapOffset, y: -40, width: 120.0, height: 30.0)
            }
        }
    }

    // MARK: - Asset loading

    override func propertiesDidChange() {
        super.propertiesDidChange()
        resetHandleViewPosition()
    }

    private func resetHandleViewPosition() {
        leftConstraint?.constant = 0
        rightConstraint?.constant = 0
        layoutIfNeeded()
    }

    // MARK: - Time Equivalence

    /// Move the position bar to the given time.
    public func seek(to time: CMTime) {
        if let newPosition = getPosition(from: time) {

            let offsetPosition = newPosition - assetPreview.contentOffset.x - leftHandleView.frame.origin.x
            let maxPosition = rightHandleView.frame.origin.x - (leftHandleView.frame.origin.x + handleWidth)
            let normalizedPosition = min(max(0, offsetPosition), maxPosition)
            positionConstraint?.constant = normalizedPosition
            layoutIfNeeded()
        }
    }

    /// The selected start time for the current asset.
    public var startTime: CMTime? {
        let startPosition = leftHandleView.frame.origin.x + assetPreview.contentOffset.x
        return getTime(from: startPosition)
    }

    /// The selected end time for the current asset.
    public var endTime: CMTime? {
        let endPosition = rightHandleView.frame.origin.x + assetPreview.contentOffset.x - handleWidth
        return getTime(from: endPosition)
    }

    private func updateSelectedTime(stoppedMoving: Bool, triggeredHandle: TriggeredHandle) {
        if stoppedMoving {
            trimmerDelegate?.positionBarStoppedMoving(triggeredHandle: triggeredHandle)
        } else {
            trimmerDelegate?.didChangePositionBar(triggeredHandle: triggeredHandle)
        }
    }

    private var minimumDistanceBetweenHandle: CGFloat {
        guard let rideDuration = rideDuration else { return 0 }
        return CGFloat(minDuration) * assetPreview.contentView.frame.width / CGFloat(rideDuration)
    }

    private var maximumDistanceBetweenHandle: CGFloat {
        guard let rideDuration = rideDuration else { return 0 }
        return CGFloat(maxDuration) * assetPreview.contentView.frame.width / CGFloat(rideDuration)
    }
    
    // MARK: - Scroll View Delegate

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateSelectedTime(stoppedMoving: true, triggeredHandle: .unknown)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateSelectedTime(stoppedMoving: true, triggeredHandle: .unknown)
        }
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSelectedTime(stoppedMoving: false, triggeredHandle: .unknown)
    }
}
