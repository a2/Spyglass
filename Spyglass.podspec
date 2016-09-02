Pod::Spec.new do |s|
  s.name             = 'Spyglass'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Spyglass.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/a2/Spyglass'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alexsander Akers' => 'me@a2.io' }
  s.source           = { :git => 'https://github.com/a2/Spyglass.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/a2'
  s.ios.deployment_target = '7.0'
  s.source_files     = 'Spyglass/Classes/**/*'
end
