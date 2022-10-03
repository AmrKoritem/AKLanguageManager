//
//  Swizzle.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 29/09/2022.
//

import Foundation

enum Swizzle {
    case instance
    case `class`

    func method(ofSelector selector: Selector, in classInstance: AnyClass) -> Method? {
        switch self {
        case .instance: return class_getInstanceMethod(classInstance, selector)
        case .class: return class_getClassMethod(classInstance, selector)
        }
    }

    func selector(_ originalSelector: Selector, with swizzledSelector: Selector, in classInstance: AnyClass) {
        let originalMethod = method(ofSelector: originalSelector, in: classInstance)
        let swizzledMethod = method(ofSelector: swizzledSelector, in: classInstance)
        swizzle(originalSelector, and: originalMethod, with: swizzledSelector, and: swizzledMethod, in: classInstance)
    }

    private func swizzle(
        _ originalSelector: Selector,
        and originalMethod: Method?,
        with swizzledSelector: Selector,
        and swizzledMethod: Method?,
        in classInstance: AnyClass
    ) {
        guard let originalMethod = originalMethod, let swizzledMethod = swizzledMethod else {
            assertionFailure("The methods are not found!")
            return
        }
        let didAddMethod = class_addMethod(
            classInstance,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod))

        guard didAddMethod else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
            return
        }
        class_replaceMethod(
            classInstance,
            swizzledSelector,
            method_getImplementation(originalMethod),
            method_getTypeEncoding(originalMethod))
    }

}
