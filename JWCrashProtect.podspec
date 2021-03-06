

Pod::Spec.new do |s|

  s.name         = "JWCrashProtect"
  s.version      = "0.0.2"
  s.summary      = "JWCrashProtect收集的一些数据、字典各种crash情况的保护措施"

  #主页
  s.homepage     = "https://github.com/junwangInChina/JWCrashProtect"
  #证书申明
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  #作者
  s.author       = { "wangjun" => "github_work@163.com" }
  #支持版本
  s.platform     = :ios, "8.1"
  #版本地址
  s.source       = { :git => "https://github.com/junwangInChina/JWCrashProtect.git", :tag => "0.0.2" }

  #库文件路径（相对于.podspec文件的路径）
  s.source_files  = "JWCrashProtect/JWCrashProtect/JWCrashProtect/**/*.{h,m}"
  #是否支持arc
  s.requires_arc = true

end
