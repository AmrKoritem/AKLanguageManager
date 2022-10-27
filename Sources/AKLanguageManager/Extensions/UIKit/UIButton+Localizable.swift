//
//  UIButton+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UIButton {
    struct AssociatedKeys {
        static var shouldLocalizeImageDirection: UInt8 = 0
    }

    /// Determines if the image should be horizontally flipped according to localization direction.
    @objc
    public var shouldLocalizeImageDirection: Bool {
        get {
            let shouldLocalizeDirection = objc_getAssociatedObject(self, &AssociatedKeys.shouldLocalizeImageDirection) as? Bool
            return shouldLocalizeDirection ?? true
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.shouldLocalizeImageDirection,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            guard !newValue else { return }
            resetImagesHorizontalDirection()
        }
    }

    @objc
    open override func localize() {
        UIControl.State.allCases.forEach { [weak self] state in
            self?.localize(for: state)
        }
        guard #available(iOS 15.0, tvOS 15.0, *) else { return }
        localizeConfiguration()
    }

    @available(iOS 15.0, tvOS 15.0, *)
    @objc
    public func localizeConfiguration() {
        localizeConfigurationTitle()
        localizeConfigurationSubtitle()
        guard shouldLocalizeImageDirection else { return }
        localizeConfigurationImage()
    }

    @available(iOS 15.0, tvOS 15.0, *)
    @objc
    public func localizeConfigurationTitle() {
        configuration?.title = configuration?.title?.localized
    }

    @available(iOS 15.0, tvOS 15.0, *)
    @objc
    public func localizeConfigurationSubtitle() {
        configuration?.subtitle = configuration?.subtitle?.localized
    }

    @available(iOS 15.0, tvOS 15.0, *)
    @objc
    public func localizeConfigurationImage() {
        configuration?.image = configuration?.image?.directionLocalized
    }

    @objc
    public func localize(for state: UIControl.State) {
        localizeTitle(for: state)
        localizeAttributedTitle(for: state)
        guard shouldLocalizeImageDirection else { return }
        localizeImage(for: state)
    }

    @objc
    public func localizeTitles() {
        UIControl.State.allCases.forEach { [weak self] state in
            self?.localizeTitle(for: state)
            self?.localizeAttributedTitle(for: state)
        }
        guard #available(iOS 15.0, *) else { return }
        localizeConfigurationTitle()
        localizeConfigurationSubtitle()
    }

    @objc
    public func localizeTitle(for state: UIControl.State) {
        setTitle(title(for: state)?.localized, for: state)
    }

    @objc
    public func localizeAttributedTitle(for state: UIControl.State) {
        setAttributedTitle(attributedTitle(for: state)?.localized, for: state)
    }

    @objc
    public func localizeImages() {
        UIControl.State.allCases.forEach { [weak self] state in
            self?.localizeImage(for: state)
        }
        guard #available(iOS 15.0, *) else { return }
        localizeConfigurationImage()
    }

    @objc
    public func localizeImage(for state: UIControl.State) {
        setImage(image(for: state)?.directionLocalized, for: state)
    }

    /// Reverts the image direction for the given state.
    @objc
    public func revertImageHorizontalDirection(for state: UIControl.State) {
        setImage(image(for: state)?.horizontalDirectionReverted, for: state)
    }

    /// Reverts the images direction for all states.
    @objc
    public func revertImagesHorizontalDirection() {
        UIControl.State.allCases.forEach { [weak self] state in
            self?.revertImageHorizontalDirection(for: state)
        }
        guard #available(iOS 15.0, *) else { return }
        configuration?.image = configuration?.image?.horizontalDirectionReverted
    }

    /// Resets the image direction for the given state.
    @objc
    public func resetImageHorizontalDirection(for state: UIControl.State) {
        setImage(image(for: state)?.horizontalDirectionChanged(to: .leftToRight), for: state)
    }

    /// Resets the images direction for all states.
    @objc
    public func resetImagesHorizontalDirection() {
        UIControl.State.allCases.forEach { [weak self] state in
            self?.resetImageHorizontalDirection(for: state)
        }
        guard #available(iOS 15.0, *) else { return }
        configuration?.image = configuration?.image?.horizontalDirectionChanged(to: .leftToRight)
    }
}

/// Avoided conforming to `CaseIterable` so as to keep this internal.
extension UIControl.State {
    static var allCases: [UIControl.State] {
        [.normal, .highlighted, disabled, .selected, .focused, .application, .reserved]
    }
}
