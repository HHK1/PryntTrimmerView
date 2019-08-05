//
//  TimestampScrollView.swift
//  PryntTrimmerView
//
//  Created by Cosmin Pahomi on 05/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public class TimestampScrollViewCell: UIView {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
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
        
        self.widthAnchor.constraint(equalToConstant: 20).isActive = true
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
        self.widthAnchor.constraint(equalToConstant: totalWidth).isActive = true
        self.backgroundColor = UIColor.purple
    }
}

public class TimestampScrollView: UIScrollView {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.blue
        
        self.setupFor(duration: 67)
    }
    
    func setupFor(duration: CGFloat) {
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
}
