#
# Be sure to run `pod lib lint XJHWKWebInterceptorKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XJHWKWebInterceptorKit'
  s.version          = '0.1.1'
  s.summary          = 'XJHWKWebInterceptorKit is a WKWebView URLProtocol Interceptor Kit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'XJHWKWebInterceptorKit is a WKWebView URLProtocol Interceptor Kit.@XJHWKWebInterceptorKit'

  s.homepage         = 'https://github.com/cocoadogs/XJHWKWebInterceptorKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cocoadogs' => 'cocoadogs@163.com' }
  s.source           = { :git => 'https://github.com/cocoadogs/XJHWKWebInterceptorKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.public_header_files = 'XJHWKWebInterceptorKit/XJHWKWebInterceptorKit.h'
  s.source_files = 'XJHWKWebInterceptorKit/XJHWKWebInterceptorKit.h'
  
  s.subspec 'DataSource' do |ss|
    ss.public_header_files = 'XJHWKWebInterceptorKit/XJHWKWebDataSource.h'
    ss.source_files = 'XJHWKWebInterceptorKit/XJHWKWebDataSource.{h,m}'
  end
  
  s.subspec 'Base' do |ss|
    ss.public_header_files = 'XJHWKWebInterceptorKit/XJHWKURLHandler.h'
    ss.source_files = 'XJHWKWebInterceptorKit/XJHWKURLHandler.{h,m}','XJHWKWebInterceptorKit/XJHWKURLProtocol.{h,m}'
    ss.dependency 'XJHWKWebInterceptorKit/DataSource'
  end
  
  s.subspec 'ViewModel' do |ss|
    ss.public_header_files = 'XJHWKWebInterceptorKit/XJHWKRequestResponseViewModel.h'
    ss.source_files = 'XJHWKWebInterceptorKit/XJHWKRequestResponseViewModel.{h,m}'
    ss.dependency 'XJHWKWebInterceptorKit/DataSource'
  end
  
  s.subspec 'Controller' do |ss|
    ss.public_header_files = 'XJHWKWebInterceptorKit/XJHWKInterceptorViewController.h'
    ss.source_files = 'XJHWKWebInterceptorKit/XJHWKInterceptorViewController.{h,m}'
    ss.dependency 'XJHWKWebInterceptorKit/ViewModel'
  end
  
  s.dependency 'XJHNetworkInterceptorKit/Util'
  s.dependency 'XJHNetworkInterceptorKit/Model'
  s.dependency 'XJHNetworkInterceptorKit/ViewModel'
  s.dependency 'XJHNetworkInterceptorKit/Cell'
  s.dependency 'XJHNetworkInterceptorKit/Controller'
  
  # s.resource_bundles = {
  #   'XJHWKWebInterceptorKit' => ['XJHWKWebInterceptorKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
