Pod::Spec.new do |s|

  s.name        = "WaveTransition"
  s.version     = "0.1"
  s.summary     = "Custom transition between viewcontrollers holding tableviews."

  s.description = <<-DESC
                  Custom transition between viewcontrollers holding tableviews in Swift.
                  DESC

  s.homepage    = "https://github.com/Limon-O-O/WaveTransition"

  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.authors           = { "Limon" => "fengninglong@gmail.com" }
  s.social_media_url  = "https://twitter.com/Limon______"

  s.ios.deployment_target   = "8.0"
  # s.osx.deployment_target = "10.7"

  s.source          = { :git => "https://github.com/Limon-O-O/WaveTransition.git", :tag => s.version }
  s.source_files    = "WaveTransition/*.swift"
  s.requires_arc    = true

end
