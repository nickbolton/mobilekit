//
//  NiblessView.swift
//  MobileKit
//
//  Created by Nick Bolton on 5/8/19.
//  Copyright © 2019 Pixelbleed LLC. All rights reserved.
//

import UIKit

public protocol Themeable: class {
  func applyTheme()
}

protocol InternalThemeable: Themeable {
}

open class NiblessView: UIView, InternalThemeable {
  
  // MARK: - Properties
  
  private (set) public var isHierarchyReady = false

  public var appContext: AppContext { AppContext.shared }

  public override init(frame: CGRect) {
    super.init(frame: frame)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @available(*, unavailable,
    message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
  )
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
  }
  
  // MARK: - Methods
  open override func didMoveToWindow() {
    super.didMoveToWindow()
    guard !isHierarchyReady else { return }
    initializeViews()
    constructHierarchy()
    activateConstraints()
    applyTheme()
    isHierarchyReady = true
    didFinishInitialization()
    NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name.ThemeChanged, object: ThemeManager.shared)
  }
  
  open func didFinishInitialization() {
  }

  open func initializeViews() {
  }

  open func constructHierarchy() {
  }
  
  open func activateConstraints() {
  }
  
  @objc open func themeChanged() {
    applyTheme()
  }
  
  open func applyTheme() {
    walkHierarchyAndApplyTheme()
  }
  
  open override func setNeedsDisplay() {
    super.setNeedsDisplay()
    applyTheme()
  }
}
