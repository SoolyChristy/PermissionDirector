Pod::Spec.new do |s|
  s.name         = "PermissionDirector"
  s.version      = "0.0.5"
  s.summary      = "iOS Permission manager."
  s.description  = <<-DESC
PermissionDirector is a iOS permission manager.
                   DESC
  s.homepage     = "https://github.com/SoolyChristy/PermissionDirector"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "SoolyChristy" => "imsooly@163.com" }
  s.source       = { :git => "https://github.com/SoolyChristy/PermissionDirector.git", :tag => s.version }
  s.source_files  = ["Sources/*.swift"]
  s.platform     = :ios, '9.0'

end
