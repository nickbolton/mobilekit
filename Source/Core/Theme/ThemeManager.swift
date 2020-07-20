//
//  ThemeManager.swift
//  MobileKit
//
//  Created by Nick Bolton on 10/29/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit

extension Notification.Name {
  static public let ThemeChanged = Notification.Name("com.pixelbleed.themeManager.themeDidChange")
}

public enum ThemeType {
  case light
  case dark
  case custom
}

public protocol Theme {
  var identifier: String { get }
  var type: ThemeType { get }
  var isDarkTheme: Bool { get }
  var defaultBackgroundColor: UIColor { get }
  var defaultAnimationDuration: TimeInterval { get }
  var statusBarStyle: UIStatusBarStyle { get }
  var blurEffectStyle: UIBlurEffect.Style { get }
  var isStatusBarHidden: Bool { get }
  var keyboardAppearance: UIKeyboardAppearance { get }
  var fontScale: CGFloat { get set }
  var headlineFont: UIFont { get }
  var bodyFont: UIFont { get }
  func scaledValue(_ value: CGFloat) -> CGFloat
  func themedImage(named: String) -> UIImage?
}

open class DefaultTheme: Theme {
  public var fontScale: CGFloat = 1.0
  public var identifier = ThemeManager.defaultLightIdentifier
  public var type = ThemeType.light
  public var isStatusBarHidden = false
  public var isDarkTheme: Bool { return type == .dark }
  public var defaultBackgroundColor: UIColor = .black
  public var defaultAnimationDuration: TimeInterval { return 0.3 }
  public var statusBarStyle: UIStatusBarStyle = .default
  public var keyboardAppearance: UIKeyboardAppearance = .light
  public var blurEffectStyle = UIBlurEffect.Style.light

  public var headlineFont: UIFont { return UIFont.boldSystemFont(ofSize: scaledValue(22.0)) }
  public var bodyFont: UIFont { return UIFont.systemFont(ofSize: scaledValue(16.0)) }
  
  public func scaledValue(_ value: CGFloat) -> CGFloat {
    return round((value * fontScale) * 2.0) / 2.0
  }
  
  public func themedImage(named name: String) -> UIImage? {
    let suffix = isDarkTheme ? "-dark" : "-light"
    return UIImage(named: name + suffix)
  }
}

open class DefaultLightTheme: DefaultTheme {
  public override init() {
    super.init()
    self.identifier = ThemeManager.defaultLightIdentifier
    self.type = .light
    self.defaultBackgroundColor = .white
    self.statusBarStyle = .default
    self.keyboardAppearance = .light
    self.blurEffectStyle = .light
  }
}

open class DefaultDarkTheme: DefaultTheme {
  public override init() {
    super.init()
    self.identifier = ThemeManager.defaultDarkIdentifier
    self.type = .dark
    self.defaultBackgroundColor = .black
    self.statusBarStyle = .lightContent
    self.keyboardAppearance = .dark
    self.blurEffectStyle = .dark
  }
}

public class ThemeManager: NSObject {
  
  static public let defaultLightIdentifier = "ThemeManager.defaultLight"
  static public let defaultDarkIdentifier = "ThemeManager.defaultDark"
  
  static public let shared = ThemeManager()
  private override init() {}
  
  private (set) var themes = [String: Theme]()
  private (set) public var selectedIdentifier: String = ""

  private var lightTheme = DefaultLightTheme()
  private var darkTheme = DefaultDarkTheme()
  
  public func currentTheme() -> Theme {
    return themes[selectedIdentifier] ?? DefaultLightTheme()
  }

  public func initialize() {
    if #available(iOS 13.0, *) {
      if UITraitCollection.current.userInterfaceStyle == .dark {
        selectDarkTheme()
      } else {
        selectLightTheme()
      }
    } else {
      selectLightTheme()
    }
  }

  public func selectDarkTheme() {
    select(theme: darkTheme)
  }

  public func selectLightTheme() {
    select(theme: lightTheme)
  }

  var contentSizeCategory: UIContentSizeCategory = UIContentSizeCategory.large {
    didSet {
      var scale = 0
      let factor: CGFloat = 0.075
      switch contentSizeCategory {
      case UIContentSizeCategory.extraSmall:
        scale = -3
      case UIContentSizeCategory.small:
        scale = -2
      case UIContentSizeCategory.medium:
        scale = -1
      case UIContentSizeCategory.large:
        scale = 0
      case UIContentSizeCategory.extraLarge:
        scale = 1
      case UIContentSizeCategory.extraExtraLarge:
        scale = 2
      case UIContentSizeCategory.extraExtraExtraLarge:
        scale = 3
      case UIContentSizeCategory.accessibilityMedium:
        scale = 4
      case UIContentSizeCategory.accessibilityLarge:
        scale = 5
      case UIContentSizeCategory.accessibilityExtraLarge:
        scale = 6
      case UIContentSizeCategory.accessibilityExtraExtraLarge:
        scale = 7
      case UIContentSizeCategory.accessibilityExtraExtraExtraLarge:
        scale = 8
      default:
        scale = 0
      }
      
      var fontScale: CGFloat = 1.0
      
      if scale > 0 {
        for _ in 1...scale {
          fontScale += factor
        }
      } else if scale < 0 {
        for _ in scale..<0 {
          fontScale -= factor
        }
      }
      
      for theme in themes.values {
        var updatedTheme = theme
        updatedTheme.fontScale = fontScale
        themes[updatedTheme.identifier] = updatedTheme
      }
    }
  }
  
  public func registerTheme(_ theme: Theme) {
    themes[theme.identifier] = theme
    if selectedIdentifier.count <= 0 {
      selectTheme(withIdentifier: theme.identifier)
    }
  }

  public func select(theme: Theme) {
    selectTheme(withIdentifier: theme.identifier)
  }

  public func fireThemeChangedNotification() {
    NotificationCenter.default.post(name: Notification.Name.ThemeChanged, object: self)
  }
  
  public func selectTheme(withIdentifier identifier: String) {
    guard themes[identifier] != nil else { return }
    let changed = selectedIdentifier != identifier
    selectedIdentifier = identifier
    contentSizeCategory = UIApplication.shared.preferredContentSizeCategory
    if changed {
      fireThemeChangedNotification()
    }
  }
}
