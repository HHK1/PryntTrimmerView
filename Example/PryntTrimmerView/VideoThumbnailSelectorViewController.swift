//
//  VideoThumbnailSelectorViewController.swift
//  PryntTrimmerView
//
//  Created by Henry on 06/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Photos
import PryntTrimmerView
import AVFoundation

class VideoThumbnailSelectorViewController: UIViewController {
 
    @IBOutlet weak var videoCropView: VideoCropView!
    @IBOutlet weak var selectThumbView: ThumbSelectorView!
    var fetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: .video, options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoCropView.aspectRatio = CGSize(width: 2, height: 3)
    }
    
    func loadAsset(_ asset: AVAsset) {
        
        selectThumbView.asset = asset
        selectThumbView.delegate = self
        videoCropView.asset = asset
        
    }
    
    @IBAction func selectAsset(_ sender: Any) {
        let randomAssetIndex = Int(arc4random_uniform(UInt32(fetchResult.count - 1)))
        let asset = fetchResult.object(at: randomAssetIndex)
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (avAsset, audioMix, info) in
            DispatchQueue.main.async {
                if let avAsset = avAsset {
                    self.loadAsset(avAsset)
                }
            }
        }
    }
    
    @IBAction func crop(_ sender: Any) {
        
        if let selectedTime = selectThumbView.selectedTime, let asset = videoCropView.asset {
            let generator = AVAssetImageGenerator(asset: asset)
            generator.requestedTimeToleranceBefore = kCMTimeZero
            generator.requestedTimeToleranceAfter = kCMTimeZero
            generator.appliesPreferredTrackTransform = true
            var actualTime = kCMTimeZero
            let image = try? generator.copyCGImage(at: selectedTime, actualTime: &actualTime)
            if let image = image {
                
                let selectedImage = UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .up)
                let croppedImage = selectedImage.crop(in: videoCropView.getImageCropFrame())!
                UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil)
                UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)
            }
        }
    }
}

extension VideoThumbnailSelectorViewController: ThumbSelectorViewDelegate {
    
    func didChangeThumbPosition(_ imageTime: CMTime) {
        videoCropView.player?.seek(to: imageTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
}

extension UIImage {
    
    func crop(in frame: CGRect) -> UIImage? {
        
        if let croppedImage = self.cgImage?.cropping(to: frame) {
            return UIImage(cgImage: croppedImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}
