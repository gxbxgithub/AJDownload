Pod::Spec.new do |s|
    s.name         = 'AJDownload'
    s.version      = '1.0.0'
    s.summary      = 'Download manager based on AFNetworking 3.0'
    s.homepage     = 'https://github.com/gxbxgithub/AJDownload'
    s.license      = 'MIT'
    s.authors      = { 'guoxb' => 'gxbxemail@163.com' }
    s.platform     = :ios, '8.0'
    s.source       = { :git => 'https://github.com/gxbxgithub/AJDownload.git', :tag => s.version.to_s }
    s.source_files = 'AJDownload/**/*.{h,m}'
    s.framework    = 'UIKit'
    s.dependency 'AFNetworking', '~> 3.1.0'
    s.requires_arc = true
end