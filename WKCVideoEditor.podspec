Pod::Spec.new do |s|
s.name         = "WKCVideoEditor"
s.version      = "1.0.0"
s.summary      = "edit video"
s.homepage     = "https://github.com/WKCLoveYang/WKCVideoEditor.git"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "WKCLoveYang" => "wkcloveyang@gmail.com" }
s.platform     = :ios, "10.0"
s.source       = { :git => "https://github.com/WKCLoveYang/WKCVideoEditor.git", :tag => "1.0.0" }
s.source_files  = "WKCVideoEditor/**/*.{h,m}"
s.public_header_files = "WKCVideoEditor/**/*.h"
s.frameworks = "Foundation", "UIKit", "Photos"
s.requires_arc = true

end
