//
//  AVPlayer+isPlaying.swift
//  PryntTrimmerView
//
//  Created by Henry on 29/03/2017.
//  Copyright © 2017 Prynt. All rights reserved.
//

import AVFoundation

extension AVPlayer {

    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}
