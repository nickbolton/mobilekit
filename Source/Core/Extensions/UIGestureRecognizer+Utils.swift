//
//  UIGestureRecognizer+Utils.swift
//  MobileKit
//
//  Created by Nick Bolton on 11/2/20.
//

import UIKit

public extension UIGestureRecognizer.State {

  var name: String {
    switch self {
    case .possible:
      return "possible"
    case .began:
      return "began"
    case .changed:
      return "changed"
    case .ended:
      return "ended"
    case .cancelled:
      return "cancelled"
    case .failed:
      return "failed"
    @unknown default:
      return "unknown"
    }
  }
}
