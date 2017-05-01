Pod::Spec.new do |s|
  s.name             = 'Spyglass'
  s.version          = '0.0.2'
  s.summary          = 'A framework for custom view-to-view interactive transitions.'
  s.homepage         = 'https://github.com/a2/Spyglass'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alexsander Akers' => 'me@a2.io' }
  s.source           = { :git => 'https://github.com/a2/Spyglass.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/a2'
  s.ios.deployment_target = '8.0'
  s.source_files     = 'Spyglass/Classes/**/*'
end
