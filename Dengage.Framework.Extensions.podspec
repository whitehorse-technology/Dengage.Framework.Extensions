#
# Be sure to run `pod lib lint Dengage.Framework.Extensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Dengage.Framework.Extensions'
  s.version          = '1.0.1-alpha'
  s.summary          = 'Dengage.Framework.Extensions contains custom categories (Carousel Notification)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Dengage.Framework.Extensions provides necessary classes and functions which handles notification for Rich Notifications
                       DESC

  s.homepage         = 'https://github.com/whitehorse-technology/Dengage.Framework.Extensions'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'GNU GPLv3', :file => 'LICENSE' }
  s.author           = { 'ekin@whitehorse.technology' => 'ekin@whitehorse.technology' }
  s.source           = { :git => 'https://github.com/whitehorse-technology/Dengage.Framework.Extensions.git', :tag => s.version.to_s }
  

  s.ios.deployment_target = '11.0'

  s.source_files = 'Dengage.Framework.Extensions/Classes/**/*'
  
  s.swift_versions = ['4.0','4.2','5.0']
  
  s.resource_bundles = {
     'Dengage.Framework.Extensions' => ['Dengage.Framework.Extensions/Views/*', 'Dengage.Framework.Extensions/*.storyboard']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'Dengage.Framework'
end
