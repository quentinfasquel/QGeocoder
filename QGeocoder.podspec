#
#  Be sure to run `pod spec lint QGeocoder.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "QGeocoder"
  s.version      = "0.5"
  s.summary      = "QGeocoder override CLGeocoder and uses Google Geocoding API"
  s.description  = <<-DESC
QGeocoder is a subclass of CLGeocoder, it provides services of forward- and reverse-geocoding.
The services use the Google Geocoding API : http://code.google.com/apis/maps/documentation/geocoding/#GeocodingRequests
If you believe google geocoding is much better..
                   DESC
  s.homepage     = "https://github.com/quentinfasquel/QGeocoder"
  s.license      = "Apache License, Version 2.0"
  s.author             = "Quentin Fasquel"
  s.social_media_url   = "http://twitter.com/quentinfasquel"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/quentinfasquel/QGeocoder.git", :tag => "0.5" }
  s.source_files  = 'QGeocoder/Classes/**/*.{h,m}'
  s.public_header_files = 'QGeocoder/Classes/*.h'
  s.frameworks = "CoreLocation", "Foundation"
  s.requires_arc = true
end
