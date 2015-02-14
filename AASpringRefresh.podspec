Pod::Spec.new do |s|
  s.name          = "AASpringRefresh"
  s.version       = "1.0"
  s.summary       = "All around Unread.app like pull to refresh library."
  s.homepage      = "https://github.com/r-plus/AASpringRefresh/"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "r-plus" => "anasthasia.r@gmail.com" }
  s.source        = { :git => "https://github.com/r-plus/AASpringRefresh.git", :tag => s.version.to_s }
  s.platform      = :ios, "7.0"
  s.source_files  = "AASpringRefresh/*.{h,m}"
  s.requires_arc  = true
end
