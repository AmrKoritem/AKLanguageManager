//
//  Swizzling+Methods.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 14/09/2022.
//

import Foundation

func swizzleInstanceSelector(_ originalSelector: Selector, with swizzledSelector: Selector, in classInstance: AnyClass) {
    let originalMethod = class_getInstanceMethod(classInstance, originalSelector)
    let swizzledMethod = class_getInstanceMethod(classInstance, swizzledSelector)
    swizzle(originalSelector, and: originalMethod, with: swizzledSelector, and: swizzledMethod, in: classInstance)
}

func swizzleClassSelector(_ originalSelector: Selector, with swizzledSelector: Selector, in classInstance: AnyClass) {
    let originalMethod = class_getClassMethod(classInstance, originalSelector)
    let swizzledMethod = class_getClassMethod(classInstance, swizzledSelector)
    swizzle(originalSelector, and: originalMethod, with: swizzledSelector, and: swizzledMethod, in: classInstance)
}

func swizzle(
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
