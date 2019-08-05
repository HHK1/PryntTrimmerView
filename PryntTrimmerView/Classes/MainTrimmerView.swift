//
//  MainTrimmerView.swift
//  PryntTrimmerView
//
//  Created by Cosmin Pahomi on 05/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public class MainTrimmerView: UIView {

    public lazy var trimmerView: TrimmerView = {
        let trimmer = TrimmerView(frame: CGRect.zero)
        trimmer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trimmer)
        return trimmer
    }()

    public lazy var timestampScroll: TimestampScrollView = {
        let timestamp = TimestampScrollView(frame: CGRect.zero)
        timestamp.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timestamp)

        timestamp.setupFor(duration: 65)
        return timestamp
    }()

    // MARK: - Initialization
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupConstraints()
    }

    // MARK: - Setup
    public func setup() {

    }

    public func setupConstraints() {
        self.trimmerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.trimmerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.trimmerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.trimmerView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        self.timestampScroll.leadingAnchor.constraint(equalTo: leadingAnchor, constant: self.trimmerView.handleWidth / 2.0).isActive = true
        self.timestampScroll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -self.trimmerView.handleWidth / 2.0).isActive = true
        self.timestampScroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.timestampScroll.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }

}
