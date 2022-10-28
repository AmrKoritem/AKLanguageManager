[![Swift](https://img.shields.io/badge/Swift-5.0+-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.0+-Orange?style=flat-square)
[![Objective C](https://img.shields.io/badge/Obj-C-orange?style=flat-square)](https://img.shields.io/badge/Obj-C-Orange?style=flat-square)
[![UIKit](https://img.shields.io/badge/UIKit-Compatible-red?style=flat-square)](https://img.shields.io/badge/UIKit-Compatible-Red?style=flat-square)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Compatible-red?style=flat-square)](https://img.shields.io/badge/SwiftUI-Compatible-Red?style=flat-square)
[![iOS](https://img.shields.io/badge/iOS-Platform-blue?style=flat-square)](https://img.shields.io/badge/iOS-Platform-Blue?style=flat-square)
[![tvOS](https://img.shields.io/badge/tvOS-Platform-blue?style=flat-square)](https://img.shields.io/badge/tvOS-Platform-Blue?style=flat-square)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-Support-yellow?style=flat-square)](https://img.shields.io/badge/CocoaPods-Support-Yellow?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-Support-yellow?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-Support-Yellow?style=flat-square)

# AKLanguageManager

A Language manager to handle changing app localization without restarting the app.<br>
  - It works on Swift and Objective C projects.<br>
  - It's compatible with both UIKit and SwiftUI.<br>
  - It supports iOS and tvOS.<br>
  - It can be integrated via Cocoa Pods and Swift Package Manager.<br>

## ScreenShots

<img src="https://raw.githubusercontent.com/AmrKoritem/AKLanguageManager/master/README/aklm-example.gif"  width="300">

## Installation

AKLanguageManager can be installed using [CocoaPods](https://cocoapods.org). Add the following lines to your Podfile:
```ruby
pod 'AKLanguageManager'
```

You can also install it using [swift package manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) as well.

## Setup

Note: If you've already configured your app to be localizable, then skip to step 3.

1 - Configure your app to be localizable by going to `PROJECT > Localisation`, then add the languages you want to support (Arabic for example), dialog will appear to ask you which resources files you want to localize (if any exist), select all the files you wish to localize.

2 - Add a `.strings` file to your project resources to localise your string literals (preferabley named `Localizable.strings`), then go to file inspector and below localization press localize.

3 - For a UIKit project, your default language must be set before your rootViewController is set using `configureWith(defaultLanguage:observedLocalizer:)`. For example, you can set it in the `AppDelegate.application(_:didFinishLaunchingWithOptions:)` method. If the default language wasn't set in your UIKit app, you will encounter errors.
```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // you can use .deviceLanguage to keep the device default language.
        AKLanguageManager.shared.defaultLanguage = .en
        return true
    }
```

4 - As for SwiftUI, add your root view as a child to `LocalizedView`.
```swift
    LocalizedView(.en) {
        ContentView()
            // Animation that will be used when localization is triggered.
            .transition(.slide)
    }
```

5 - Note that you will have to call `localized()` on presented views.
```swift
    VStack {
        ...
    }
    .popover(isPresented: $isPresented) { // same goes for other presentation styles.
        AnotherView()
            .localized()
    }
```

Note: The default language is the language your app will be localized in when it runs first time.

## Usage

1 - If you want to change the language, use the `setLanguage(language:)` method by passing to it the new language.<br>
In a UIKit project, at least the parameter `viewControllerFactory` must be provided in addition to the language:
```swift
    // Change Language and set rootViewController to the initial view controller
    @IBAction func changeLanguage() {
        // Swap between anglish and arabic languages
        let newLanguage = AKLanguageManager.shared.selectedLanguage == .en ? Language.ar : Language.en
        AKLanguageManager.shared.setLanguage(
            language: newLanguage,
            viewControllerFactory: { windowTitle in
                // The view controller that you want to show after changing the language
                let settingsVC = Storyboard.Main.instantiate(viewController: SettingsViewController.self)
                return Storyboard.Main.initialViewController ?? settingsVC
            },
            animation: { view in
                // Do custom animation
                view.alpha = 0
            }
        )
    }
```

In a SwiftUI project only the language is needed:
```swift
import SwiftUI
import AKLanguageManager

struct LangaugeView: View {
    var body: some View {
        VStack {
            Text("Select a language".localized)
                .fontWeight(.bold)
                .padding()
            HStack {
                Button("العربية") {
                    withAnimation {
                        AKLanguageManager.shared.setLanguage(language: .ar)
                    }
                }
                .padding()
                Spacer()
                Button("English") {
                    withAnimation {
                        AKLanguageManager.shared.setLanguage(language: .en)
                    }
                }
                .padding()
            }
        }
    }
}
```

2 - Note that images change direction by default in UIKit UI elements according to the language direction. If you want a UI element (for example: UIImageView) not to change its direction, you can set its `shouldLocalizeDirection` property to `false`.
```swift
    @IBOutlet weak var fixedImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Make the image direction fixed even when localization direction change
        fixedImageView.shouldLocalizeDirection = false
    }
```

3 - Note that images are fixed by default in SwiftUI views. If you want to change an image's direction according to the selected language direction, use the method `directionLocalized()`.
```swift
    Image("image")
        .directionLocalized()
```

4 - String, Int, and Double can be localized using the property `localized`.
```swift
    // where selected language is .ar
    print("01.10 key".localized)
    // prints ٠١٫١٠ مفتاح
    print(01.10.localized)
    // prints ٠١٫١٠
    print(01.localized)
    // prints ٠١
```

5 - Numbers are localized by default, you can stop numbers localization by setting the property `shouldLocalizeNumbers` to `false`.
```swift
    // where selected language is .ar
    AKLanguageManager.shared.shouldLocalizeNumbers = false
    print("01.10 key".localized)
    // prints 01.10 مفتاح
```

## Examples

You can check the example project here to see AKLanguageManager in action 🥳.<br>
You can check a full set of examples [here](https://github.com/AmrKoritem/AKLibrariesExamples) as well.

## Contribution 🎉

All contributions are welcome.Feel free to check the [Known issues](https://github.com/AmrKoritem/AKLanguageManager#known-issues) and [Future plans](https://github.com/AmrKoritem/AKLanguageManager#future-plans) sections if you don't know where to start. And of course feel free to raise your own issues and create PRs for them 💪

## Known issues 🫣

1 - Strings shown in launch screen are not localized. [#6](https://github.com/AmrKoritem/AKLanguageManager/issues/6)<br>
    Unfortunately, this is intended by apple as stated [here](https://developer.apple.com/design/human-interface-guidelines/patterns/launching/#:~:text=Avoid%20including%20text%20on%20your%20launch%20screen.).

2 - Localized version of an image asset doesn't show when changing app language. [#7](https://github.com/AmrKoritem/AKLanguageManager/issues/7)<br>
    We are currently looking into this issue. The current workaround is to use different names for each image localization, and get them using localized strings.
    
3 - SF Symbol images size is reduced when their direction change. [#8](https://github.com/AmrKoritem/AKLanguageManager/issues/8)<br>

## Future plans 🧐

1 - Get localized strings with comments. [#9](https://github.com/AmrKoritem/AKLanguageManager/issues/9)<br>
2 - Localizing plurals. [#10](https://github.com/AmrKoritem/AKLanguageManager/issues/10)<br>
3 - Carthage support. [#11](https://github.com/AmrKoritem/AKLanguageManager/issues/11)<br>
4 - Check text language. [#12](https://github.com/AmrKoritem/AKLanguageManager/issues/12)<br>

## Credit 😇

This library was inspired by [Abedalkareem's LanguageManager-iOS](https://github.com/Abedalkareem/LanguageManager-iOS) library. Please check his work and give him the credit he deserves 🚀

## Find me 🥰

[LinkedIn](https://www.linkedin.com/in/amr-koritem-976bb0125/)

## License

Please check the license file.
