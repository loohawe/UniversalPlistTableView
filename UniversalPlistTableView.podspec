#
# Be sure to run `pod lib lint UniversalPlistTableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  s.name             = 'UniversalPlistTableView'
  s.version          = '0.1.8'
  s.summary          = 'Universal Plist TableView.'
  s.description      = <<-DESC
    Unbelieveable table view, very nice, god damn genius.
                       DESC

  s.homepage         = 'https://github.com/loohawe/UniversalPlistTableView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'loohawe@gmail.com' => 'loohawe@gmail.com' }
  s.source           = { :git => 'git@github.com:loohawe/UniversalPlistTableView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'UniversalPlistTableView/**/*.{h,m,swift}'
#s.resource = "UniversalPlistTableView/Images.xcassets"
  s.resource_bundles = {
    'Resources' => ['UniversalPlistTableView/**/*.{png,xib,plist}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'SnapKit'
  
end
