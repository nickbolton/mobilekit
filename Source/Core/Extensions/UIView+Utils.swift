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
  
  public func removeCornerRounding() {
    layer.mask = nil
  }
  
  public func roundLeftCorners(radius: CGFloat, rect: CGRect? = nil) {
    let corners = UIRectCorner.topLeft.union(.bottomLeft)
    let path = UIBezierPath(roundedRect: rect ?? bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
  
  public func roundRightCorners(radius: CGFloat, rect: CGRect? = nil) {
    let corners = UIRectCorner.topRight.union(.bottomRight)
    let path = UIBezierPath(roundedRect: rect ?? bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
  
  public func roundTopCorners(radius: CGFloat, rect: CGRect? = nil) {
    let corners = UIRectCorner.topRight.union(.topLeft)
    let path = UIBezierPath(roundedRect: rect ?? bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
  
  public func roundBottomCorners(radius: CGFloat, rect: CGRect? = nil) {
    let corners = UIRectCorner.bottomRight.union(.bottomLeft)
    let path = UIBezierPath(roundedRect: rect ?? bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
  
  public func roundCorners(corners: UIRectCorner, radius: CGFloat, rect: CGRect? = nil) {
    let path = UIBezierPath(roundedRect: rect ?? bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
}
