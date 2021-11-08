//
//  UIView+Animation.swift
//  MobileKit
//
//  Copyright © 2020 Pixelbleed LLC. All rights reserved.
//

import UIKit

extension UIView {
  static func springAnimation(
    withDuration duration: TimeInterval,
    delay: TimeInterval = 0.0,
    usingSpringWithDamping damping: CGFloat = 1.0,
    initialSpringVelocity velocity: CGFloat = 0.0,
    options: UIView.AnimationOptions = .defaultAnimationOptions,
    animations: @escaping () -> Void,
    completion: ((Bool) -> Void)? = nil)
  {
    UIView.animate(
      withDuration: duration,
      delay: delay,
      usingSpringWithDamping: damping,
      initialSpringVelocity: velocity,
      options: options,
      animations: animations,
      completion: completion)
  }
}

