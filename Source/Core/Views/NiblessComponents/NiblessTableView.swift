//
//  NiblessTableView.swift
//  MobileKit
//
//  Created by Nick Bolton on 5/8/19.
//  Copyright © 2019 Pixelbleed LLC. All rights reserved.
//

import Foundation
import UIKit

open class NiblessTableView: UITableView {
  public override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name.ThemeChanged, object: ThemeManager.shared)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @available(*, unavailable,
  message: "Loading this table view from a nib is unsupported in favor of initializer dependency injection."
  )
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading this table view from a nib is unsupported in favor of initializer dependency injection.")
  }
    
  @objc open func themeChanged() {
    applyTheme()
  }
  
  open func applyTheme() {
    walkHierarchyAndApplyTheme()
  }
}

