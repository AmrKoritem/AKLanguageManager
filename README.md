# AKLanguageManager

A Language manager to handle changing app localization without restarting the app.

## ScreenShots

<img src="https://raw.githubusercontent.com/AmrKoritem/AKLanguageManager/master/README/aklm-example.gif"  width="300">

## Installation

LanguageManager-iOS is not yet available through [CocoaPods](https://cocoapods.org).

For now, you can use [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

## Setup

Note: If you've already configured your app to be localizable, then skip to step 3.

1 - Configure your app to be localizable by going to `PROJECT > Localisation`, then add the languages you want to support (Arabic for example), dialog will appear to ask you which resources files you want to localize (if any exist), select all the files you wish to localize.

2 - Add a `.strings` file to your project resources to localise your string literals (preferabley named `Localizable.strings`), then go to file inspector and below localization press localize.

3 - For a UIKit, your default language must be set before your rootViewController is set using `configureWith(defaultLanguage:observedLocalizer:)`. For example, you can set it in the `AppDelegate.application(_:didFinishLaunchingWithOptions:)` method. If the default language wasn't set in your UIKit app, you will encounter errors.
```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // you can use .deviceLanguage to keep the device default language.
        AKLanguageManager.shared.configureWith(defaultLanguage: .en)
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

5 - Note that you will have to call `localized()` on views that will be presented.
```swift
    VStack {
        ...
    }
    .popover(isPresented: $isPresented) {
        AnotherView()
            .localized()
    }
```

6 - The default language is the language your app will be localized in when it runs first time.

## Usage

1 - If you want to change the language in a UIKit, use the `setLanguage(language:)` method by passing to it the new language.
```swift
    // Change Language and set rootViewController to the initial view controller
    @IBAction func changeLanguage() {
        // Swap between anglish and arabic languages
        let newLanguage = AKLanguageManager.shared.selectedLanguage == .en ? Language.ar : Language.en
        AKLanguageManager.shared.setLanguage(
            language: newLanguage,
            viewControllerFactory: { _ in
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

2 - Note that images change direction by default in UIKit UI elements according to the language direction. If you want a UI element (for example: UIImageView) not to change its direction, you can set its `shouldLocalizeDirection` property to `false`.
```swift
    @IBOutlet weak var fixedImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Make the image direction fixed even when localization direction change
        fixedImageView.shouldLocalizeDirection = false
    }
```

3 - If you want to change the language in a SwiftUI set the `selectedLanguage` property in the environment object with the new language.
```swift
import SwiftUI
import AKLanguageManager

struct LangaugeView: View {
    @EnvironmentObject
    var localizer: ObservedLocalizer

    var body: some View {
        VStack {
            Text("Select a language".localized)
                .fontWeight(.bold)
                .padding()
            HStack {
                Button("العربية") {
                    withAnimation {
                        localizer.selectedLanguage = .ar
                    }
                }
                .padding()
                Spacer()
                Button("English") {
                    withAnimation {
                        localizer.selectedLanguage = .en
                    }
                }
                .padding()
            }
        }
    }
}
```

4 - Note that images are fixed by default in SwiftUI views. If you want to change an image's direction according to the selected language direction, use the method `directionLocalized()`.
```swift
    Image("image")
        .directionLocalized()
```

Please check the example project in this repo to see how it works. You can check a full set of examples [here](https://github.com/AmrKoritem/AKLibrariesExamples) as well.

## Contribution

All contributions are welcome. Please check the [Known issues] and [Future plans] sections if you don't know where to start. And of course feel free to raise your own issues and create PRs for them!

## Known issues

1 - Strings shown in launch screen are not localized. [#6](https://github.com/AmrKoritem/AKLanguageManager/issues/6)
    Unfortunately, this is intended by apple as stated [here](https://developer.apple.com/design/human-interface-guidelines/patterns/launching/#:~:text=Avoid%20including%20text%20on%20your%20launch%20screen.).

2 - Localized version of an image asset doesn't show when changing app language. [#7](https://github.com/AmrKoritem/AKLanguageManager/issues/7)
    We are currently looking into this issue. The current workaround is to use different names for each image localization, and get them using localized strings.
    
3 - SF Symbol images size is reduced when their direction change. [#8](https://github.com/AmrKoritem/AKLanguageManager/issues/8)

## Future plans

1 - Get localized strings with comments. [#9](https://github.com/AmrKoritem/AKLanguageManager/issues/9)
2 - Localizing plurals. [#10](https://github.com/AmrKoritem/AKLanguageManager/issues/10)
3 - Carthage support. [#11](https://github.com/AmrKoritem/AKLanguageManager/issues/11)
4 - Check text language. [#12](https://github.com/AmrKoritem/AKLanguageManager/issues/12)

## Credit

This library was inspired by [Abedalkareem's LanguageManager-iOS](https://github.com/Abedalkareem/LanguageManager-iOS) library. Please check his work and give him the credit he deserves 🚀

## Follow me

[LinkedIn](https://www.linkedin.com/in/amr-koritem-976bb0125/)

## License

Please check the license file.
