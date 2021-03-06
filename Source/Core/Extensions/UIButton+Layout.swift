//
//  UIButton+Layout.swift
//  Bedrock
//
//  Created by Nick Bolton on 7/14/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import UIKit

public extension UIButton {
  
  static let minTappableDimension: CGFloat = 44.0
  static let minTappableSize = CGSize(width: minTappableDimension, height: minTappableDimension)
  
  @discardableResult
  func alignImageLeft(width:CGFloat, offset:CGFloat = 0.0) -> NSLayoutConstraint {
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageWidth = image(for: .normal)?.size.width ?? 0.0
    let constant = offset - ((width - imageWidth) / 2.0)
    let result = NSLayoutConstraint(item: self,
                                    attribute: .left,
                                    relatedBy: .equal,
                                    toItem: self.superview,
                                    attribute: .left,
                                    multiplier: 1.0,
                                    constant: constant)
    NSLayoutConstraint.activate([result])
    
    return result
  }
  
  @discardableResult
  func alignImageSafeAreaLeft(width: CGFloat, offset: CGFloat = 0.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    assert(superview != nil, "Not part of any view hierarchy")
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageWidth = image(for: .normal)?.size.width ?? 0.0
    let constant = offset - ((width - imageWidth) / 2.0)
    let result = leftAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leftAnchor, constant: constant)
    result.priority = priority
    NSLayoutConstraint.activate([result])
    return result
  }
  
  @discardableResult
  func alignImageLeft(toLeftOf:UIView, width:CGFloat, offset:CGFloat = 0.0) -> NSLayoutConstraint {
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageWidth = image(for: .normal)?.size.width ?? 0.0
    let constant = offset - ((width - imageWidth) / 2.0)
    let result = NSLayoutConstraint(item: self,
                                    attribute: .left,
                                    relatedBy: .equal,
                                    toItem: toLeftOf,
                                    attribute: .left,
                                    multiplier: 1.0,
                                    constant: constant)
    NSLayoutConstraint.activate([result])
    
    return result
  }
  
  @discardableResult
  func alignImageRight(width:CGFloat, offset:CGFloat = 0.0) -> NSLayoutConstraint {
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageWidth = image(for: .normal)?.size.width ?? 0.0
    let constant = offset + ((width - imageWidth) / 2.0)
    let result = NSLayoutConstraint(item: self,
                                    attribute: .right,
                                    relatedBy: .equal,
                                    toItem: self.superview,
                                    attribute: .right,
                                    multiplier: 1.0,
                                    constant: constant)
    NSLayoutConstraint.activate([result])
    
    return result
  }
  
  @discardableResult
  func alignImageSafeAreaRight(width: CGFloat, offset: CGFloat = 0.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    assert(superview != nil, "Not part of any view hierarchy")
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageWidth = image(for: .normal)?.size.width ?? 0.0
    let constant = offset + ((width - imageWidth) / 2.0)
    let result = leftAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leftAnchor, constant: constant)
    result.priority = priority
    NSLayoutConstraint.activate([result])
    return result
  }
  
  @discardableResult
  func alignImageRight(toRightOf:UIView, width:CGFloat, offset:CGFloat = 0.0) -> NSLayoutConstraint {
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageWidth = image(for: .normal)?.size.width ?? 0.0
    let constant = offset + ((width - imageWidth) / 2.0)
    let result = NSLayoutConstraint(item: self,
                                    attribute: .right,
                                    relatedBy: .equal,
                                    toItem: toRightOf,
                                    attribute: .right,
                                    multiplier: 1.0,
                                    constant: constant)
    NSLayoutConstraint.activate([result])
    
    return result
  }
  
  @discardableResult
  func alignImageTop(height:CGFloat, offset:CGFloat = 0.0) -> NSLayoutConstraint {
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageHeight = image(for: .normal)?.size.height ?? 0.0
    let constant = offset - ((height - imageHeight) / 2.0)
    let result = NSLayoutConstraint(item: self,
                                    attribute: .top,
                                    relatedBy: .equal,
                                    toItem: self.superview,
                                    attribute: .top,
                                    multiplier: 1.0,
                                    constant: constant)
    NSLayoutConstraint.activate([result])
    
    return result
  }
  
  @discardableResult
  func alignImageSafeAreaTop(height: CGFloat, offset: CGFloat = 0.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    translatesAutoresizingMaskIntoConstraints = false
    assert(superview != nil, "Not part of any view hierarchy")
    let imageHeight = image(for: .normal)?.size.height ?? 0.0
    let constant = offset - ((height - imageHeight) / 2.0)
    let result = topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor, constant: constant)
    result.priority = priority
    NSLayoutConstraint.activate([result])
    return result
  }
  
  @discardableResult
  func alignImageTop(toTopOf:UIView, height:CGFloat, offset:CGFloat = 0.0) -> NSLayoutConstraint {
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageHeight = image(for: .normal)?.size.height ?? 0.0
    let constant = offset - ((height - imageHeight) / 2.0)
    let result = NSLayoutConstraint(item: self,
                                    attribute: .top,
                                    relatedBy: .equal,
                                    toItem: toTopOf,
                                    attribute: .top,
                                    multiplier: 1.0,
                                    constant: constant)
    NSLayoutConstraint.activate([result])
    return result
  }
  
  @discardableResult
  func alignImageTop(toBottomOf:UIView, height:CGFloat, offset:CGFloat = 0.0) -> NSLayoutConstraint {
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageHeight = image(for: .normal)?.size.height ?? 0.0
    let constant = offset - ((height - imageHeight) / 2.0)
    let result = NSLayoutConstraint(item: self,
                                    attribute: .top,
                                    relatedBy: .equal,
                                    toItem: toBottomOf,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: constant)
    NSLayoutConstraint.activate([result])
    return result
  }
  
  @discardableResult
  func alignImageTop(toBaselineOf:UIView, height:CGFloat, offset:CGFloat = 0.0) -> NSLayoutConstraint {
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageHeight = image(for: .normal)?.size.height ?? 0.0
    let constant = offset - ((height - imageHeight) / 2.0)
    let result = NSLayoutConstraint(item: self,
                                    attribute: .top,
                                    relatedBy: .equal,
                                    toItem: toBaselineOf,
                                    attribute: .lastBaseline,
                                    multiplier: 1.0,
                                    constant: constant)
    NSLayoutConstraint.activate([result])
    return result
  }

  @discardableResult
  func alignImageBottom(height:CGFloat, offset:CGFloat = 0.0) -> NSLayoutConstraint {
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageHeight = image(for: .normal)?.size.height ?? 0.0
    let constant = offset + ((height - imageHeight) / 2.0)
    let result = NSLayoutConstraint(item: self,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: self.superview,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: constant)
    NSLayoutConstraint.activate([result])
    
    return result
  }
  
  @discardableResult
  func alignImageSafeAreaBottom(height: CGFloat, offset: CGFloat = 0.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    assert(superview != nil, "Not part of any view hierarchy")
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageHeight = image(for: .normal)?.size.height ?? 0.0
    let constant = offset + ((height - imageHeight) / 2.0)
    let result = bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor, constant: constant)
    result.priority = priority
    NSLayoutConstraint.activate([result])
    return result
  }
  
  @discardableResult
  func alignImageBottom(toBottomOf:UIView, height:CGFloat, offset:CGFloat = 0.0) -> NSLayoutConstraint {
    self.translatesAutoresizingMaskIntoConstraints = false
    let imageHeight = image(for: .normal)?.size.height ?? 0.0
    let constant = offset + ((height - imageHeight) / 2.0)
    let result = NSLayoutConstraint(item: self,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: toBottomOf,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: constant)
    NSLayoutConstraint.activate([result])
    
    return result
  }
}
