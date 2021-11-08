//
//  View+Helpers.swift
//  MobileKit
//
//  Copyright © 2020 Pixelbleed LLC All rights reserved.
//

import UIKit

public extension UIView {

  var statusBarHeight: CGFloat {
    let defaultHeight = UIApplication.shared.statusBarFrame.height
    if #available(iOS 13.0, *) {
      return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? defaultHeight
    }
    return defaultHeight
  }
  
  var safeRegionInsets: UIEdgeInsets {
    if #available(iOS 11, *) {
      return safeAreaInsets
    }
    return .zero
  }
}
