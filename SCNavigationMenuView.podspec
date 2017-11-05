#
#  Be sure to run `pod spec lint SCNavigationMenuView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "SCNavigationMenuView"
  s.version      = "0.5.0"
  s.summary      = "SCNavigationMenuView provide a NavigationBar MenuView."
  s.description  = "SCNavigationMenuView provide a NavigationBar MenuView. It is a easy way."

  s.homepage     = "https://github.com/TalkingJourney/SCNavigationMenuView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "TalkingJourney" => "https://github.com/TalkingJourney" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/TalkingJourney/SCNavigationMenuView.git", :tag => "0.5.0" }

  s.source_files = "SCNavigationMenuView/**/*.{h,m,png}"
  s.public_header_files = "SCNavigationMenuView/**/*.h"
  s.requires_arc = true

end
