#
# Be sure to run `pod lib lint UINavigationControllerWithCompletionBlock.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "UINavigationControllerWithCompletionBlock"
  s.version          = "0.0.8"
  s.summary          = "The UINavigationController missing methods, push/pop with completionBlocks."
  s.description      = <<-DESC
                       The UINavigationController missing methods, push/pop with completionBlocks.
                       It's now possible to push/pop viewControllers Controller with completionBlocks.
                       oh Yeah !
                       DESC
  s.homepage         = "https://github.com/leverdeterre/UINavigationControllerWithCompletionBlock"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Jérôme Morissard" => "morissardj@gmail.com" }
  s.source           = { :git => "https://github.com/leverdeterre/UINavigationControllerWithCompletionBlock.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'UINavigationControllerWithCompletionBlock' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'JRSwizzle', '~> 1.0'
end