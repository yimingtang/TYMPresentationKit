Pod::Spec.new do |s|
  s.name             = "TYMPresentationKit"
  s.version          = "0.1.0"
  s.summary          = "A presentation library for iOS."
  s.description      = <<-DESC
                       A library that makes presentation easier in iOS.
                       DESC
  s.homepage         = "https://github.com/yimingtang/TYMPresentationKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Yiming Tang" => "yimingnju@gmail.com" }
  s.source           = { :git => "https://github.com/yimingtang/TYMPresentationKit.git", :tag => "v#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'TYMPresentationKit/Classes/**/*'
  s.resource_bundles = {
    'TYMPresentationKit' => ['TYMPresentationKit/Assets/*.png']
  }

  # s.public_header_files = 'TYMPresentationKit/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
