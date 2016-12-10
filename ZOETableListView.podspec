Pod::Spec.new do |s|
#name必须与文件名一致
s.name              = "ZOETableListView"

#更新代码必须修改版本号
s.version           = "1.0.1"
s.summary           = "a titleView selector for ios."
s.description       = <<-DESC
It is a titleView selector used on iOS, which implement by Objective-C.
DESC
s.homepage          = "https://github.com/ChenZhenChun/ZOETableListView"
s.license           = 'MIT'
s.author            = { "ChenZhenChun" => "346891964@qq.com" }

#submodules 是否支持子模块
s.source            = { :git => "https://github.com/ChenZhenChun/ZOETableListView.git", :tag => s.version, :submodules => true}
s.platform          = :ios, '7.0'
s.requires_arc = true

#source_files路径是相对podspec文件的路径

#核心模块
s.subspec 'ZOETableListView' do |ss|
ss.source_files = 'ZOETableListView/ZOETableListView/*.{h,m}'
ss.public_header_files = 'ZOETableListView/ZOETableListView/*.h'
end

#子模块image(存放图片)
s.subspec 'image' do |ss|
ss.resources = 'ZOETableListView/image/*.png'
end

s.frameworks = 'Foundation', 'UIKit'

# s.ios.exclude_files = 'Classes/osx'
# s.osx.exclude_files = 'Classes/ios'
# s.public_header_files = 'Classes/**/*.h'

end
