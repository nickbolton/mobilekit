//
//  NiblessNavigationController.swift
//  MobileKit
//
//  Created by Nick Bolton on 5/8/19.
//  Copyright © 2019 Pixelbleed LLC. All rights reserved.
//

import UIKit

open class NiblessNavigationController: UINavigationController {
  
  public var appContext = AppContext.shared
  
  open override var preferredStatusBarStyle: UIStatusBarStyle {
    return ThemeManager.shared.currentTheme().statusBarStyle
  }
  
  public init() {
    super.init(nibName: nil, bundle: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name.ThemeChanged, object: ThemeManager.shared)
  }

  public override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
    NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name.ThemeChanged, object: ThemeManager.shared)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @available(*, unavailable,
    message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
  )
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  @available(*, unavailable,
    message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
  )
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
  }
    
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    applyTheme()
  }
    
  @objc open func themeChanged() {
    applyTheme()
  }
  
  open func applyTheme() {
    view.walkHierarchyAndApplyTheme()
  }
}
