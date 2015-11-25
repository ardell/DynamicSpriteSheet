#
# Be sure to run `pod lib lint DynamicSpriteSheet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DynamicSpriteSheet"
  s.version          = "0.0.6"
  s.summary          = "Create sprite sheets at runtime from UIImages"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
Need to send a bunch of small user-created images over the wire, but don't want
to open a request for each one? Compile them into a sprite sheet at runtime and
send a single image instead.
DESC

  s.homepage         = "https://github.com/ardell/DynamicSpriteSheet"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Jason Ardell" => "ardell@gmail.com" }
  s.source           = { :git => "https://github.com/ardell/DynamicSpriteSheet.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'DynamicSpriteSheet' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

