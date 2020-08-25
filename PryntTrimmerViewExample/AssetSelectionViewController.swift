//
//  AssetSelectionViewController.swift
//  PryntTrimmerView
//
//  Created by Henry on 25/06/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Photos

class AssetSelectionViewController: UIViewController {

    var fetchResult: PHFetchResult<PHAsset>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLibrary()
    }

    func loadLibrary() {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.fetchResult = PHAsset.fetchAssets(with: .video, options: nil)
            }
        }
    }

    func loadAssetRandomly() {
        guard let fetchResult = fetchResult, fetchResult.count > 0 else {
            print("Error loading assets.")
            return
        }

        let randomAssetIndex = Int(arc4random_uniform(UInt32(fetchResult.count - 1)))
        let asset = fetchResult.object(at: randomAssetIndex)
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (avAsset, _, _) in
            DispatchQueue.main.async {
                if let avAsset = avAsset {
                    self.loadAsset(avAsset)
                }
            }
        }
    }

    func loadAsset(_ asset: AVAsset) {
        // override in subclass
    }
}
