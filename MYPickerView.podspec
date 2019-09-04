#
# Be sure to run `pod lib lint MYPickerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MYPickerView'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MYPickerView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wenmingyan1990@gmail.com/MYPickerView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wenmingyan1990@gmail.com' => 'wenmy@tuya.com' }
  s.source           = { :git => 'https://github.com/WenMingYan/MYPickerView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'MYPickerView/Classes/**/*'
  

  s.prefix_header_contents = <<-EOF
    #ifdef __OBJC__
      #ifndef    weakify
        #if __has_feature(objc_arc)

        #define weakify( x ) \\
        _Pragma("clang diagnostic push") \\
        _Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
        autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \\
        _Pragma("clang diagnostic pop")

        #else

        #define weakify( x ) \\
        _Pragma("clang diagnostic push") \\
        _Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
        autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \\
        _Pragma("clang diagnostic pop")

        #endif
        #endif

        #ifndef    strongify
        #if __has_feature(objc_arc)

        #define strongify( x ) \\
        _Pragma("clang diagnostic push") \\
        _Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
        try{} @finally{} __typeof__(x) x = __weak_##x##__; \\
        _Pragma("clang diagnostic pop")

        #else

        #define strongify( x ) \\
        _Pragma("clang diagnostic push") \\
        _Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
        try{} @finally{} __typeof__(x) x = __block_##x##__; \\
        _Pragma("clang diagnostic pop")

        #endif
        #endif

    #endif
  EOF
  # s.resource_bundles = {
  #   'MYPickerView' => ['MYPickerView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry'
end
