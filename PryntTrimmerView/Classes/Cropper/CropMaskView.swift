//
//  CropMaskView.swift
//  PryntTrimmerView
//
//  Created by Henry on 10/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class CropMaskView: UIView {
    
    var lineWidth: CGFloat = 3.0 {
        didSet {
            setNeedsLayout()
        }
    }

    let cropBoxView = UIView()
    let frameView = UIView()
    let maskLayer = CAShapeLayer()
    let frameLayer = CAShapeLayer()
    
    var cropFrame: CGRect = CGRect.zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.opacity = 1.0
        
        frameLayer.strokeColor = UIColor.white.cgColor
        frameLayer.fillColor = UIColor.clear.cgColor
        
        frameView.layer.addSublayer(frameLayer)
        cropBoxView.layer.mask = maskLayer
        
        cropBoxView.translatesAutoresizingMaskIntoConstraints = false
        cropBoxView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        addSubview(cropBoxView)
        addSubview(frameView)
        
        cropBoxView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cropBoxView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cropBoxView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cropBoxView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(rect: bounds)
        let framePath = UIBezierPath(rect: cropFrame)
        path.append(framePath)
        path.usesEvenOddFillRule = true
        maskLayer.path = path.cgPath

        framePath.lineWidth = lineWidth
        frameLayer.path = framePath.cgPath
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
}
