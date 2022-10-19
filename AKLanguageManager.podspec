Pod::Spec.new do |s|

s.ios.deployment_target = '13.0'
s.tvos.deployment_target = '13.0'
s.name = "AKLanguageManager"
s.summary = "AKLanguageManager is a language manager for iOS and tvOS applications."
s.requires_arc = true

s.version = "1.0.1"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Amr Koritem" => "amr.koritem92@gmail.com" }
s.homepage = "https://github.com/AmrKoritem/AKLanguageManager"
s.source = { :git => "https://github.com/AmrKoritem/AKLanguageManager.git",
             :tag => "#{s.version}" }

s.framework = "SwiftUI"
s.source_files = "Sources/AKLanguageManager/**/*.{swift}"
s.swift_version = "5.0"

end
