//
//  UIView+Utils.swift
//  MobileKit
//
//  Created by Nick Bolton on 5/8/19.
//  Copyright © 2019 Pixelbleed LLC. All rights reserved.
//

import UIKit

extension UIView {
    
  func walkHierarchyAndApplyTheme() {
    walkViewHierarchy { v -> Bool in
      if let themeable = v as? Themeable {
        themeable.applyTheme()
      }
      return (v as? InternalThemeable) != nil
    }
  }

  public func convertCenter(to: UIView!) -> CGPoint {
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    return convert(center, to: to)
  }
  
  // handler returns true if it shouldn't descend into subviews
  public func walkViewHierarchy(_ handler: (UIView)->Bool) {
    for v in subviews {
      if handler(v) { continue }
      v.walkViewHierarchy(handler)
    }
  }
}
