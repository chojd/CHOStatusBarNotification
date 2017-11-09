#
# Be sure to run `pod lib lint CHOStatusBarNotification.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CHOStatusBarNotification'
  s.version          = '0.1.0'
  s.summary          = 'Display Notifications On Status Bar'

  s.description      = <<-DESC
            Display Notifications On Status Bar
                       DESC

  s.homepage         = 'https://github.com/chojd/CHOStatusBarNotification'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gene' => 'jingda.cao@gmail.com' }
  s.source           = { :git => 'https://github.com/chojd/CHOStatusBarNotification.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/JingdaCao'

  s.ios.deployment_target = '8.0'

  s.default_subspec = 'Core'

  s.public_header_files = 'Sources/Core/*.h'

  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/Core/*'
    ss.dependency 'CHOStatusBarNotification/View'
  end

  s.subspec 'View' do |ss|
    ss.source_files = 'Sources/View/*'
  end

  s.frameworks = 'UIKit', 'Foundation'
end
