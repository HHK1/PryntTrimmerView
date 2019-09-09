//
//  TimestampScrollView.swift
//  PryntTrimmerView
//
//  Created by Cosmin Pahomi on 05/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public class TimestampScrollView: UIScrollView {
    public var font: UIFont? {
        didSet {
            self.refresh()
        }
    }
    
    public var color: UIColor? {
        didSet {
            self.refresh()
        }
    }
    
    private var duration: CGFloat = CGFloat.zero
    private var cSize: CGSize = CGSize.zero
    
    // MARK: - Public
    public func addDotsWithLabelsFor(_ duration: CGFloat, withContentsSize cSize: CGSize) {
        self.duration = duration
        self.cSize = cSize
        
        // Remove everything and add again
        subviews.forEach { $0.removeFromSuperview() }
        setup()

        contentSize = cSize

        let spaceBetween = cSize.width / duration
        var lastDot: UIView?
        let numberOfDots = Int(duration)
        var dotSize: CGFloat = 3
        for i in 0...numberOfDots {

            if i % 5 == 0 {
                dotSize = 5
            } else {
                dotSize = 2
            }

            let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: dotSize, height: dotSize))
            circle.backgroundColor = self.color ?? UIColor.black
            circle.translatesAutoresizingMaskIntoConstraints = false
            addSubview(circle)

            circle.widthAnchor.constraint(equalToConstant: dotSize).isActive = true
            circle.heightAnchor.constraint(equalToConstant: dotSize).isActive = true
            circle.layer.cornerRadius = dotSize / 2

            if let lView = lastDot {
                let leading = spaceBetween - circle.frame.width / 2 - lView.frame.width / 2
                circle.leadingAnchor.constraint(equalTo: lView.trailingAnchor, constant: leading).isActive = true
                circle.centerYAnchor.constraint(equalTo: lView.centerYAnchor).isActive = true
            } else {
                circle.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                circle.topAnchor.constraint(equalTo: topAnchor).isActive = true
            }

            lastDot = circle

            if i % 5 == 0 {
                // Add label
                let textString = i < 10 ? ":0\(i)" : ":\(i)"
                let label = UILabel()
                label.text = textString
                label.translatesAutoresizingMaskIntoConstraints = false
                addSubview(label)
                label.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 8).isActive = true
                label.centerXAnchor.constraint(equalTo: circle.centerXAnchor).isActive = true
                label.widthAnchor.constraint(equalToConstant: 30).isActive = true
                label.textAlignment = .center
                label.textColor = self.color ?? UIColor.black

                label.font = self.font ?? label.font.withSize(13)
            }
        }
    }

    // MARK: - Private
    private func setup() {
        showsHorizontalScrollIndicator = false
        clipsToBounds = false
    }
    
    // Refresh with the last data
    private func refresh() {
        self.addDotsWithLabelsFor(self.duration, withContentsSize: self.cSize)
    }
}
