//
//  Window.swift
//  MobileKit
//
//  Created by Nick Bolton on 12/20/19.
//

import UIKit

class Window: UIWindow {

    public static let userInterfaceStyleDidChangeNotification = Notification.Name(
        rawValue: "com.pixelbleed.window.userInterfaceStyleDidChangeNotification"
    )

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13, *),
            previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle
        {
            NotificationCenter.default.post(
                name: Window.userInterfaceStyleDidChangeNotification,
                object: self
            )
            
            for locker in LockerManager.shared.lockers {
                if let defaultLocker = locker as? DefaultLocker {
                    defaultLocker.currentUserInterfaceStyle = traitCollection.userInterfaceStyle
                }
            }
            
            switch traitCollection.userInterfaceStyle {
            case .dark:
                if let theme = (ThemeManager.shared.themes.values.filter { $0 is DefaultDarkTheme }).first {
                    ThemeManager.shared.selectThemeNamed(theme.name)
                }
            default:
                if let theme = (ThemeManager.shared.themes.values.filter { $0 is DefaultLightTheme }).first {
                    ThemeManager.shared.selectThemeNamed(theme.name)
                }
            }
        }
    }
}
