//
//  TimestampScrollView.swift
//  PryntTrimmerView
//
//  Created by Cosmin Pahomi on 05/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public class TimestampScrollView: UIScrollView {
    public func addDotsWithLabelsFor(_ duration: CGFloat, withContentsSize cSize: CGSize) {
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
            circle.backgroundColor = UIColor.red
            circle.translatesAutoresizingMaskIntoConstraints = false
            addSubview(circle)

            circle.topAnchor.constraint(equalTo: topAnchor).isActive = true
            circle.widthAnchor.constraint(equalToConstant: dotSize).isActive = true
            circle.heightAnchor.constraint(equalToConstant: dotSize).isActive = true
            circle.layer.cornerRadius = dotSize / 2

            if let lView = lastDot {
                let leading = spaceBetween - circle.frame.width / 2 - lView.frame.width / 2
                circle.leadingAnchor.constraint(equalTo: lView.trailingAnchor, constant: leading).isActive = true
            } else {
                circle.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
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

                label.font = label.font.withSize(13)
            }
        }
    }

    // MARK: - Private
    private func setup() {
        isUserInteractionEnabled = false
        showsHorizontalScrollIndicator = false
        clipsToBounds = false
    }
}
