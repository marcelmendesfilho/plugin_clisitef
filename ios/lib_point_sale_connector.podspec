#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint lib_point_sale_connector.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'lib_point_sale_connector'
  s.version          = '0.0.1'
  s.summary          = 'Plugin for POS'
  s.description      = <<-DESC
  LibPointSaleConnector is a Dart package that provides an interface for interacting with the Point of Sale (POS) system, specifically designed for CliSiTef integration.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.vendored_libraries = 'Classes/lib/libclisitef_Legado.a'
  s.public_header_files = 'Classes/ClisitefAsync.h'
end
