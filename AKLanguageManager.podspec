Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "AKLanguageManager"
s.summary = "AKLanguageManager is a language manager for iOS applications."
s.requires_arc = true

s.version = "0.1.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Amr Koritem" => "amr.koritem92@gmail.com" }
s.homepage = "https://github.com/AmrKoritem/AKLanguageManager"
s.source = { :git => "https://github.com/AmrKoritem/AKLanguageManager.git",
             :tag => "#{s.version}" }

s.framework = "UIKit"
s.source_files = "AKLanguageManager/**/*.{swift}"
s.swift_version = "5.0"

end
