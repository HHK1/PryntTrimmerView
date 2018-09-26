# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.0.0]

### Added

Add swift 4.2 compatibility

## [2.0.1]

### Added

Add Carthage compatibility
Add prebuilt framework for Carthage

### Changed

Fix a crash when calculating the thumbnail preview if the frame has not been set yet. (Thanks @NikKovIos)

## [2.0.0]

### Added

- Support for swift 4

## [1.0.1] - 2017-06-25

### Added

- preload the first image in the asset thumbnails.
- add a code of conduct
- add a changelog

### Changed

- refactor the two use case examples and load assets after receiving library access


## [1.0.0] - 2017-04-25
### Added
- Add Thumbnail selection component
- Add cropping video view
- Add color customization options

### Changed
- Enrich the Readme with examples
- Refactor the trimmer view with a common base class with the thumbnail selection view
- Fix a crash in the thumbnail generation


## [0.2.0] - 2017-04-04

### Added
- Add an accessor to set the max duration on the trimmer view

### Changed
- Load assets randomly in the example
- Use tags to identify thumbnails
- Fix issues with thumbnails size


## [0.1.0] - 2017-03-29
### Added
- Add a first version of the trimmer view

[Unreleased]: https://github.com/prynt/PryntTrimmerView/compare/3.0.0...master
[3.0.0]: https://github.com/prynt/PryntTrimmerView/compare/2.0.1...3.0.0
[2.0.1]: https://github.com/prynt/PryntTrimmerView/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/prynt/PryntTrimmerView/compare/1.0.1...2.0.0
[1.0.1]: https://github.com/prynt/PryntTrimmerView/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/prynt/PryntTrimmerView/compare/0.2.0...1.0.0
[0.2.0]: https://github.com/prynt/PryntTrimmerView/compare/0.1.0...0.2.0
