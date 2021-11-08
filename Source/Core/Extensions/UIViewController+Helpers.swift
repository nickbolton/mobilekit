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

  // MARK: Popover Helpers

  public func presentInPopoverIfAvailable(_ viewController: UIViewController, animated: Bool, sourceView: UIView? = nil, arrowDirection: UIPopoverArrowDirection? = nil, onComplete: DefaultHandler? = nil) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      viewController.modalPresentationStyle = .popover
    }
    configurePopover(viewController.popoverPresentationController, sourceView: sourceView, arrowDirection: arrowDirection)
    present(viewController, animated: animated, completion: onComplete)
  }

  private func configurePopover(_ popover: UIPopoverPresentationController?, sourceView: UIView?, arrowDirection: UIPopoverArrowDirection?) {
    guard let popoverPresentationController = popover else { return }

    if let sourceView = sourceView {
      popoverPresentationController.sourceView = sourceView
      if let arrowDirection = arrowDirection {
        popoverPresentationController.permittedArrowDirections = arrowDirection
        switch arrowDirection {
        case .up:
          popoverPresentationController.sourceRect = CGRect(x: sourceView.bounds.width / 2.0, y: sourceView.bounds.height, width: 1.0, height: 1.0)
        case .down:
          popoverPresentationController.sourceRect = CGRect(x: sourceView.bounds.width / 2.0, y: 0.0, width: 1.0, height: 1.0)
        case .left:
          popoverPresentationController.sourceRect = CGRect(x: sourceView.bounds.width, y: sourceView.bounds.height / 2.0, width: 1.0, height: 1.0)
        case .right:
          popoverPresentationController.sourceRect = CGRect(x: 0.0, y: sourceView.bounds.height / 2.0, width: 1.0, height: 1.0)
        default: ()
        }
      } else {
        popoverPresentationController.permittedArrowDirections = []
      }
    } else {
      popoverPresentationController.sourceView = self.view
      popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
      popoverPresentationController.permittedArrowDirections = []
    }
  }
}
