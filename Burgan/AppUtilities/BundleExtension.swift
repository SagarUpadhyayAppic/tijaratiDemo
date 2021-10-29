//
//  BundleExtension.swift
//  Burgan
//
//  Created by Malti Maurya on 06/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

// MARK: Localizable
//public protocol Localizable {
//    var localized: String { get }
//}
//
//extension String: Localizable {
//    public var localized: String {
//        return NSLocalizedString(self, comment: "")
//    }
//}
//
//// MARK: XIBLocalizable
//public protocol XIBLocalizable {
//    var xibLocKey: String? { get set }
//}
//
//extension UILabel: XIBLocalizable {
//    @IBInspectable public var xibLocKey: String? {
//        get { return nil }
//        set(key) {
//            text = key?.localized
//        }
//    }
//}
//
//extension UIButton: XIBLocalizable {
//    @IBInspectable public var xibLocKey: String? {
//        get { return nil }
//        set(key) {
//            setTitle(key?.localized, for: .normal)
//        }
//    }
//}
//
//extension UINavigationItem: XIBLocalizable {
//    @IBInspectable public var xibLocKey: String? {
//        get { return nil }
//        set(key) {
//            title = key?.localized
//        }
//    }
//}
//
//extension UIBarItem: XIBLocalizable { // Localizes UIBarButtonItem and UITabBarItem
//    @IBInspectable public var xibLocKey: String? {
//        get { return nil }
//        set(key) {
//            title = key?.localized
//        }
//    }
//}
//
//// MARK: Special protocol to localize multiple texts in the same control
//public protocol XIBMultiLocalizable {
//    var xibLocKeys: String? { get set }
//}
//
//extension UISegmentedControl: XIBMultiLocalizable {
//    @IBInspectable public var xibLocKeys: String? {
//        get { return nil }
//        set(keys) {
//            guard let keys = keys?.components(separatedBy: ","), !keys.isEmpty else { return }
//            for (index, title) in keys.enumerated() {
//                setTitle(title.localized, forSegmentAt: index)
//            }
//        }
//    }
//}
//
//// MARK: Special protocol to localizaze UITextField's placeholder
//public protocol UITextFieldXIBLocalizable {
//    var xibPlaceholderLocKey: String? { get set }
//}
//
//extension UITextField: UITextFieldXIBLocalizable {
//    @IBInspectable public var xibPlaceholderLocKey: String? {
//        get { return nil }
//        set(key) {
//            placeholder = key?.localized
//        }
//    }
//}
