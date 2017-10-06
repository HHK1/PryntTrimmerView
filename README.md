# PryntTrimmerView

[![codebeat badge](https://codebeat.co/badges/ac008534-7f30-4b04-8434-0c6d69251e4b)](https://codebeat.co/projects/github-com-prynt-prynttrimmerview-master)
[![Platform](https://img.shields.io/cocoapods/p/PryntTrimmerView.svg?style=flat)](http://cocoapods.org/pods/PryntTrimmerView)
[![License](https://img.shields.io/cocoapods/l/PryntTrimmerView.svg?style=flat)](http://cocoapods.org/pods/PryntTrimmerView)
[![Version](https://img.shields.io/cocoapods/v/PryntTrimmerView.svg?style=flat)](http://cocoapods.org/pods/PryntTrimmerView)

A set of tools written in swift to crop and trim videos.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Trimming

![](https://media.giphy.com/media/GwZGkLiKxZcTm/giphy.gif)

### Cropping

![](https://media.giphy.com/media/10FsDfHS7616XC/giphy.gif)

## Requirements

PryntTrimmerView requires iOS9: It uses Layout Anchors to define the constraints.

## Installation

PryntTrimmerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PryntTrimmerView"
```

For swift 3 compatibility, you can use version 1.0.1 or below.

## Usage

### Trimming

Create a `TrimmerView` instance (in interface builder or through code), and add it to your view hierarchy.

```
trimmerView.asset = asset
trimmerView.delegate = self
```

Access the `startTime` and `endTime` property to know where to trim your asset. You can use the `TrimmerViewDelegate` to link the trimmer with an `AVPlayer` and provide the end user with a preview. See the `VideoTrimmerViewController` inside the project to see an example.

You can also customize the trimmer view by changing its colors:
```
trimmerView.handleColor = UIColor.white
trimmerView.mainColor = UIColor.orange
trimmerView.positionBarColor = UIColor.white
```

### Cropping

Create an instance of the `VideoCropView` and add it to your view hierarchy, then load your video into the crop view: `videoCropView.asset = asset`.

You can set the aspect ratio you want using the `setAspectRatio` method. Once you are satisfied with the portion of the asset you want to crop, call `getImageCropFrame` to retrieve the select frame. See the `VideoCropperViewController` in the example app for an actual example of how to crop the video for export.

## License

PryntTrimmerView is available under the MIT license. See the LICENSE file for more info.
