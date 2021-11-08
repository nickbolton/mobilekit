//
//  UIWindow+Utils.swift
//  MobileKit
//
//  Copyright © 2020 Pixelbleed LLC All rights reserved.
//

import UIKit

public extension UIWindow {
  
  static var currentWindow: UIWindow { UIApplication.shared.windows.filter { $0.isKeyWindow }.first! }
  
  static var topWindowLevel: UIWindow.Level { topWindow.windowLevel }
  
  static var topWindow: UIWindow {
    let windows = UIApplication.shared.windows
    var topWindow: UIWindow = windows.first!
    
    for window in windows {
      if window.windowLevel.rawValue >= topWindow.windowLevel.rawValue {
        topWindow = window
      }
    }
    return topWindow
  }
  
  static func addToTopWindow(view: UIView) {
    topWindow.addSubview(view)
  }
  
  func moveToTop() {
    var maxLevel: CGFloat = 0.0
    for idx in 0..<UIApplication.shared.windows.count {
      let window = UIApplication.shared.windows[idx]
      guard window !== self else { continue }
      maxLevel = max(maxLevel, window.windowLevel.rawValue)
    }
    windowLevel = UIWindow.Level(rawValue: maxLevel + 1.0)
  }
}
