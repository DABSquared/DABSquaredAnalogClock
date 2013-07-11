Pod::Spec.new do |s|
  s.name         = "DABSquaredAnalogClock"
  s.version      = 1.0.0"
  s.summary      = "A class for making analog style clocks with your own provided images."
  s.homepage     = "https://github.com/DABSquared/DABSquaredAnalogClock"
  s.license      = 'MIT'
  s.author       = { "DABSquared" => "support@dabsquared.com" }
  s.source       = { :git => "https://github.com/DABSquared/DABSquaredAnalogClock.git", :tag => "1.0.0" }
  s.platform     = :ios, '5.0'
  s.source_files = 'AnalogClockWithImages/DABSquaredAnalogClockView.{h,m}'
  s.resources    = "AnalogClockWithImages/clock*.png"
  s.requires_arc = true
end
