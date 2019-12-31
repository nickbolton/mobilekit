//
//  UIApplication+Utils.swift
//  MobileKit
//
//  Created by Nick Bolton on 12/25/19.
//

import UIKit

extension UIApplication {
  
  var modalStatusBarHeight: CGFloat {
    if #available(iOS 13, *) {
      return 0.0
    }
    return statusBarFrame.height
  }
}
