//
//  TimestampScrollView.swift
//  PryntTrimmerView
//
//  Created by Cosmin Pahomi on 05/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public class DotView: UIView {

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    // MARK: - Public
//    public class func dotWithSize(_ dotSize: CGFloat) -> DotView {
//
//        let circle = DotV
//        circle.backgroundColor = UIColor.red
//        circle.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(circle)
//        circle.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        circle.widthAnchor.constraint(equalToConstant: dotSize).isActive = true
//        circle.heightAnchor.constraint(equalToConstant: dotSize).isActive = true
//        circle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        circle.layer.cornerRadius = dotSize / 2
//
////        let label = UILabel()
////        label.text = textLabel
////        label.translatesAutoresizingMaskIntoConstraints = false
////        addSubview(label)
////        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
////        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
////
////        label.font = label.font.withSize(13)
////
////        widthAnchor.constraint(equalToConstant: 20).isActive = true
//    }
}

public class TimestampScrollViewCell: UIView {

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    // MARK: - Public
    public func setupWithLabel(_ textLabel: String) {
        let dotSize: CGFloat = 6

        let circle = UIView()
        circle.backgroundColor = UIColor.red
        circle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(circle)
        circle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        circle.widthAnchor.constraint(equalToConstant: dotSize).isActive = true
        circle.heightAnchor.constraint(equalToConstant: dotSize).isActive = true
        circle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circle.layer.cornerRadius = dotSize / 2

        let label = UILabel()
        label.text = textLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        label.font = label.font.withSize(13)

        widthAnchor.constraint(equalToConstant: 20).isActive = true
    }

    public func setupWithDots(_ numberOfDots: Int) {
        var lastDot: UIView?
        let dotSize: CGFloat = 3
        let distanceBetweenDots: CGFloat = 8

        for _ in 0...numberOfDots - 1 {

            let circle = UIView()
            circle.backgroundColor = UIColor.red
            circle.translatesAutoresizingMaskIntoConstraints = false
            addSubview(circle)
            circle.topAnchor.constraint(equalTo: topAnchor, constant: 1.5).isActive = true
            circle.widthAnchor.constraint(equalToConstant: dotSize).isActive = true
            circle.heightAnchor.constraint(equalToConstant: dotSize).isActive = true
            circle.layer.cornerRadius = dotSize / 2

            if let last = lastDot {
                circle.leadingAnchor.constraint(equalTo: last.trailingAnchor, constant: distanceBetweenDots).isActive = true
            } else {
                circle.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            }

            lastDot = circle
        }

        let totalWidth = CGFloat(numberOfDots) * dotSize + (CGFloat(numberOfDots) - 1) * distanceBetweenDots
        widthAnchor.constraint(equalToConstant: totalWidth).isActive = true
    }
}

public class TimestampScrollView: UIScrollView {
    public func addDotsFor(_ duration: CGFloat, withContentsSize cSize: CGSize) {
        contentSize = cSize

        let stackView = UIStackView(frame: CGRect.zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = UIColor.blue
        addSubview(stackView)

        let numberOfDots = Int(cSize.width / duration)
        let dotSize: CGFloat = 3

        for _ in 0...numberOfDots - 1 {
            let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: dotSize, height: dotSize))
            circle.backgroundColor = UIColor.red
            circle.translatesAutoresizingMaskIntoConstraints = true
            stackView.addArrangedSubview(circle)
            circle.widthAnchor.constraint(equalToConstant: dotSize).isActive = true
            circle.layer.cornerRadius = dotSize / 2
        }

        stackView.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: dotSize).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }

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
//            circle.setNeedsLayout()

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
//                label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                label.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 8).isActive = true
                label.centerXAnchor.constraint(equalTo: circle.centerXAnchor).isActive = true
                label.widthAnchor.constraint(equalToConstant: 30).isActive = true
                label.textAlignment = .center
//                label.heightAnchor.constraint(equalToConstant: 30).isActive = true

                label.font = label.font.withSize(13)

            }

//            let dotView = TimestampScrollViewCell()
//            addSubview(timestampCell)
//            let number = i * 5
//            let textString = number < 10 ? ":0\(number)" : ":\(number)"
//            timestampCell.setupWithLabel(textString)
//
//            timestampCell.topAnchor.constraint(equalTo: topAnchor).isActive = true
//            timestampCell.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//
//            if let lView = lastView {
//                timestampCell.leadingAnchor.constraint(equalTo: lView.trailingAnchor, constant: 0).isActive = true
//            } else {
//                timestampCell.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//            }
//
//            lastView = timestampCell as TimestampScrollViewCell
        }
    }

    // MARK: - Public
    public func setupFor(duration: CGFloat, spaceBetweenSeconds: CGFloat) {
        // Remove everything and add again
        subviews.forEach { $0.removeFromSuperview() }

        setup()

        var lastView: TimestampScrollViewCell?
        let numberOfLabelCells = Int(duration / 5)

        for i in 0...numberOfLabelCells {
            let timestampCell = TimestampScrollViewCell()
            addSubview(timestampCell)
            let number = i * 5
            let textString = number < 10 ? ":0\(number)" : ":\(number)"
            timestampCell.setupWithLabel(textString)

            timestampCell.topAnchor.constraint(equalTo: topAnchor).isActive = true
            timestampCell.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

            if let lView = lastView {
                timestampCell.leadingAnchor.constraint(equalTo: lView.trailingAnchor, constant: 0).isActive = true
            } else {
                timestampCell.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            }

            lastView = timestampCell as TimestampScrollViewCell

            // If last
            if i == numberOfLabelCells {
                timestampCell.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            } else {
                // add a dots view
                let timestampCell = TimestampScrollViewCell()
                addSubview(timestampCell)
                timestampCell.setupWithDots(4)

                timestampCell.topAnchor.constraint(equalTo: topAnchor).isActive = true
                timestampCell.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

                if let lView = lastView {
                    timestampCell.leadingAnchor.constraint(equalTo: lView.trailingAnchor, constant: 0).isActive = true
                } else {
                    timestampCell.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                }

                lastView = timestampCell as TimestampScrollViewCell
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
