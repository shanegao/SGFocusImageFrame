Pod::Spec.new do |s|
  s.name         = "SGFocusImageItem"
  s.platform     = :ios
  s.version      = "1.0.1"
  s.summary      = "Focus Image scroll View"
  s.homepage     = "https://github.com/shanegao/SGFocusImageFrame"
  s.license      = "MIT"
  s.authors      = { "Shane Gao" => "weigaox@gmail.com"}
  s.source       = { :git => "https://github.com/shanegao/SGFocusImageFrame.git", :tag => '1.0.0' }
  s.framework    = 'QuartzCore', 'UIKit'
  s.source_files = '*.{h,m}'
  s.requires_arc = true
end