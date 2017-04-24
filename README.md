# PryntTrimmerView

A set of tools written in swift to crop and trim videos.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Trimming 

![](https://media.giphy.com/media/GwZGkLiKxZcTm/giphy.gif)

## Requirements

## Installation

PryntTrimmerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PryntTrimmerView"
```

## Usage

### Trimming 

Create a `TrimmerView` instance (in interface builder or through code), and add it to your view hierarchy.

```
trimmerView.asset = asset
trimmerView.delegate = self
```

Access the `startTime` and `endTime` property to know where to trim your asset. You can use the `TrimmerViewDelegate` to link the trimmer with an `AVPlayer` and provide the end user with a preview. See the project to see an example.


## License

PryntTrimmerView is available under the MIT license. See the LICENSE file for more info.
