# Release process documentation

The package is published with cocoapods, SPM, and Carthage.


1. Update the version number in the .podspec file:  [Semantic Versioning](http://semver.org/spec/v2.0.0.html).
1. Update the Changelog. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
1. Build the framework with `carthage build --no-skip-current` and `carthage archive PryntTrimmerView`
1. Commit the changes and add a tag with the same version number (this is sufficient for the SPM support)
1. Push the  commit and the  tag to github
1. Publish your pod to the trunk: `pod trunk push PryntTrimmerView.podspec --allow-warnings`
1. Link the framework in the github release
