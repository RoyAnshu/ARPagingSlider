Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '9.0'
s.name = "ARPagingSlider"
s.summary = "ARPagingSlider lets a user to create paging slider."
#s.requires_arc = true

# 2
s.version = "1.1"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Anshu" => "iosdeveloperanshu@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/RoyAnshu/ARPagingSlider"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/RoyAnshu/ARPagingSlider.git", 
             :tag => "#{s.version}" }

# 7
s.framework = "UIKit"

# 8
s.source_files = "ARPagingSlider/**/*.{swift}"

# 9
#s.resources = "ARPagingSlider/**/*.{png,jpeg,jpg}"

# 10
s.swift_version = "4.2"

end