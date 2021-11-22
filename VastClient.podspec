Pod::Spec.new do |s|
  s.name = 'VastClient'
  s.authors = { 'Craig Holliday' => 'craig.holliday@realeyes.com'}
  s.version = '3.0.0'
  s.license = 'MIT'
  s.summary = 'Vast Client is a Swift Framework which implements the VAST 4.0 spec'
  s.homepage = 'https://github.com/realeyes-media/ios-vast-client'
  s.source = { :git => 'https://github.com/realeyes-media/ios-vast-client', :tag => s.version }
  s.tvos.deployment_target = '11.0'
  s.ios.deployment_target = '11.0'
  s.source_files = 'Sources/VastClient/**/*.swift'
end
