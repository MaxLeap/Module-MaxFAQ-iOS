#
# Be sure to run `pod lib lint MaxLeap.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MaxFAQ"
  s.version          = "0.0.1"
  s.summary          = "MaxLeap Services provides all-in-one cloud services for developers."


# This description is used to generate ƒtags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  # s.description      = <<-DESC
  #                      DESC

  s.homepage         = "https://maxleap.com"
  s.license          = { :type => 'Creative Commons Zero v1.0 Universal',
                         :file => 'LICENSE.txt' }
  s.author           = "MaxLeap"
  s.source           = { :git => "https://github.com/MaxLeap/Module-MaxFAQ-iOS.git",
                         :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Source/*.{h,m}', 'Source/**/*.{h,m}', 'Source/**/**/*.{h,m}'
  s.public_header_files = 'Source/UI/*.h', 'Source/Data/*.h'
  s.resource = 'Source/Resources/*.bundle'

  s.frameworks = 'Foundation', 'UIKit'

  s.dependency 'MaxLeap', '~> 2.0.10'

end
