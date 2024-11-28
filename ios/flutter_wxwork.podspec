#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_wxwork.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_wxwork'
  s.version          = '0.0.3'
  s.summary          = '企业微信登录授权flutter插件。'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/andfaraway/flutter_wxwork'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'levikaslana@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.vendored_libraries = 'Assets/libWXWorkApi.a'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.frameworks = ['WebKit']

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
