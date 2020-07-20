//
//  UIViewController+Helpers.swift
//  MobileKit
//
//  Created by Nick Bolton on 7/14/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: Safe Area
    
    public var safeRegionInsets: UIEdgeInsets { return view.safeRegionInsets }

    public func wrapInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }

    @discardableResult
    public func presentViewControllerInNavigation(vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) -> UINavigationController {
        let nav = vc.wrapInNavigationController()
        present(nav, animated: animated, completion: completion)
        return nav
    }

    public func showChild(_ viewController: UIViewController, in containerIn: UIView? = nil) {
        guard let container = containerIn ?? view else { return }
        viewController.willMove(toParent: self)
        viewController.view.frame = container.bounds
        container.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)
    }

    public func removeAsChild() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        didMove(toParent: nil)
    }
    
    // MARK: Navigation
    
    public func navigateTo(vc: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(vc, animated: animated)
    }
}
