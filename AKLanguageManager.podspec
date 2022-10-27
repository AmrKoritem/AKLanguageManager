Pod::Spec.new do |s|

s.name = "AKLanguageManager"
s.summary = "AKLanguageManager is a language manager for iOS and tvOS applications."
s.requires_arc = true

s.version = "2.0.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Amr Koritem" => "amr.koritem92@gmail.com" }
s.homepage = "https://github.com/AmrKoritem/AKLanguageManager"
s.source = { :git => "https://github.com/AmrKoritem/AKLanguageManager.git",
             :tag => "v#{s.version}" }

s.framework = "SwiftUI"
s.source_files = "Sources/AKLanguageManager/**/*.{swift}"
s.swift_version = "5.0"
s.ios.deployment_target = '13.0'
s.tvos.deployment_target = '13.0'

end
