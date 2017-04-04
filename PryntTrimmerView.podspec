#
# Be sure to run `pod lib lint PryntTrimmerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PryntTrimmerView'
  s.version          = '0.2.0'
  s.summary          = 'A trimmer view to help you select a portion of an AVAsset.'

  s.description      = <<-DESC
A trimmer view to help you select a portion of an AVAsset. It provides you with a customizable component that indicates the portion of the video selected, thanks to image thumbnails of the asset.
                       DESC

  s.homepage         = 'https://github.com/prynt/PryntTrimmerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'henryhuck@hotmail.fr' => 'henryhuck@hotmail.fr' }
  s.source           = { :git => 'https://github.com/prynt/PryntTrimmerView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'PryntTrimmerView/Classes/**/*'

end
