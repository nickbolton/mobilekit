//
//  LoaderView.swift
//  MobileKit
//
//  Created by Nick Bolton on 7/14/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import UIKit

public class LoaderView: NiblessView {
  
  static private (set) public var shared: LoaderView = {
    return loaderView()
  }()
  
  static public func loaderView() -> LoaderView {
    let frameworkBundle = Bundle(for: LoaderView.self)
    let image = UIImage(named: "spinner", in: frameworkBundle, compatibleWith: nil)
    return LoaderView(image: image)
  }
  
  private let backgroundView = UIView()
  private let progressImageView = UIImageView()
  private (set) public var isAnimating = false
  private var ignoringInteractionCount = 0
  
  private let rotationAnimationKey = "rotationAnimation"
  
  weak private var ownerView: UIView?
  
  required public init(image: UIImage?, backgroundColor: UIColor = .clear) {
    self.backgroundView.backgroundColor = backgroundColor
    self.progressImageView.image = image
    super.init(frame: .zero)
    alpha = 0.0
    self.backgroundColor = .clear
  }
  
  var isVisible = false {
    didSet {
      if isVisible {
        show(in: self)
      } else {
        hide(from: self)
      }
    }
  }
  
  // MARK: View Hierarchy Construction
  
  override public func constructHierarchy() {
    super.constructHierarchy()
    addSubview(backgroundView)
    addSubview(progressImageView)
  }
  
  override public func activateConstraints() {
    super.activateConstraints()
    translatesAutoresizingMaskIntoConstraints = false
    constrainProgressImageView()
    constrainBackgroundView()
  }
  
  private func constrainProgressImageView() {
    if let image = progressImageView.image {
      NSLayoutConstraint.activate([
        progressImageView.widthAnchor.constraint(equalToConstant: image.size.width),
        progressImageView.heightAnchor.constraint(equalToConstant: image.size.height),
        progressImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        progressImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
  }
  
  private func constrainBackgroundView() {
    NSLayoutConstraint.activate([
      backgroundView.widthAnchor.constraint(equalTo: widthAnchor),
      backgroundView.heightAnchor.constraint(equalTo: heightAnchor),
      backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
      backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
      ])
  }
  
  // MARK: Public
  
  public func show(in view: UIView, animated: Bool = true, ignoreInteractionEvents: Bool = true, animations: (()->Void)? = nil, onCompletion: (()->Void)? = nil) {
    ownerView = view
    if view != self {
      view.addSubview(self)
    }
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalTo: view.widthAnchor),
      heightAnchor.constraint(equalTo: view.heightAnchor),
      centerXAnchor.constraint(equalTo: view.centerXAnchor),
      centerYAnchor.constraint(equalTo: view.centerYAnchor),
      ])
    if ignoreInteractionEvents {
      ignoringInteractionCount += 1
      UIApplication.shared.beginIgnoringInteractionEvents()
    }
    startAnimation()
    UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
      self.alpha = 1.0
      animations?()
    }) { _ in
      onCompletion?()
    }
  }
  
  public func hide(from view: UIView, animated: Bool = true, animations: (()->Void)? = nil, onCompletion: (()->Void)? = nil) {
    guard ownerView == nil || view == ownerView || superview != nil else {
      animations?()
      onCompletion?()
      return
    }
    ownerView = nil
    let deadline = DispatchTime.now() + (animated ? 0.1 : 0.0)
    DispatchQueue.main.asyncAfter(deadline: deadline) {
      let duration = animated ? 0.3 : 0.0
      UIView.animate(withDuration: duration, animations: {
        self.alpha = 0.0
        animations?()
      }) { _ in
        if self.ignoringInteractionCount > 0 {
          self.ignoringInteractionCount -= 1
          UIApplication.shared.endIgnoringInteractionEvents()
        }
        self.stopAnimation()
        if view != self {
          self.removeFromSuperview()
        }
        onCompletion?()
      }
    }
  }
  
  public func clear() {
    ownerView = nil
  }
  
  // MARK: Helpers
  
  private func startAnimation() {
    
    guard !isAnimating else {
      return
    }
    
    isAnimating = true
    let fullSpinInterval: TimeInterval = 1.0
    
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    animation.toValue = CGFloat(2.0 * Double.pi)
    animation.duration = fullSpinInterval
    animation.isCumulative = true
    animation.repeatCount = Float.greatestFiniteMagnitude
    
    progressImageView.layer.add(animation, forKey: rotationAnimationKey)
  }
  
  private func stopAnimation() {
    guard isAnimating else {
      return
    }
    isAnimating = false
    progressImageView.layer.removeAnimation(forKey: rotationAnimationKey)
  }
}
