#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint aliyun_log_dart_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'aliyun_log_dart_sdk'
  s.version          = '0.0.1'
  s.summary          = 'Aliyun Log Service for dart & flutter.'
  s.description      = <<-DESC
Aliyun Log Service for dart & flutter.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'aliyun-sls' => 'keyu404@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AliyunLogProducer/Producer', '3.1.13'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
