//
//  MainTrimmerView.swift
//  PryntTrimmerView
//
//  Created by Cosmin Pahomi on 05/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public class MainTrimmerView: UIView {
    
    var trimmerView = TrimmerView(frame: CGRect.zero)
    var timestampScroll = TimestampScrollView(frame: CGRect.zero)

    // MARK: - Initialization
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setupConstraints()
    }
    
    // MARK: - Setup
    public func setup() {
        
    }
    
    public func setupConstraints() {
        self.trimmerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.trimmerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.trimmerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.trimmerView.heightAnchor.constraint(equalToConstant: 60)
        
        self.timestampScroll.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.timestampScroll.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.timestampScroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.timestampScroll.heightAnchor.constraint(equalToConstant: 30)
    }

}
