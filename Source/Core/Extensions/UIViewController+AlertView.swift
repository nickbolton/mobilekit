//
//  UIViewController+AlertView.swift
//  Redbeard
//
//  Created by Nick Bolton on 7/14/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import UIKit
import Reachability

public extension UIViewController {
  
  private struct AssociatedKey {
    static var alertView = "mobilekit_alertView"
  }
  
  // MARK: - Properties
  
  private (set) var mk_alertView: AlertView? {
    get { return objc_getAssociatedObject(self, &AssociatedKey.alertView) as? AlertView }
    set { objc_setAssociatedObject(self, &AssociatedKey.alertView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
  
  func showAlertView(error: Error?, retryHandler: DefaultHandler? = nil) {
    if !(Reachability()?.isReachable ?? false) {
      showNoInternetConnectionAlertView()
    } else {
      showGenericAlertView()
    }
  }
  
  func showRetryingAlertView(error: Error?, retryHandler: DefaultHandler? = nil) {
    if !(Reachability()?.isReachable ?? false) {
      showNoInternetConnectionAlertView()
    } else {
      showGenericRetryingAlertView(retryHandler: retryHandler)
    }
  }
  
  func showNoInternetConnectionAlertView() {
    if let alert = mk_alertView {
      switch alert.actionType {
      case .noInternet:
        return
      default:
        break
      }
    }
    dismissCurrentAlertView()
    let alertView = AlertView()
    mk_alertView = alertView
    alertView.show(type: .noInternet, in: view, onDismiss: { [weak self] in
      self?.mk_alertView = nil
    })
  }
  
  func showRetryInternetRequestAlertView(retryHandler: DefaultHandler? = nil) {
    dismissCurrentAlertView()
    let alertView = AlertView()
    mk_alertView = alertView
    alertView.show(type: .retryInternetRequest(handler: retryHandler ?? {}), in: view, onDismiss: { [weak self] in
      self?.mk_alertView = nil
    })
  }
  
  private func showGenericAlertView() {
    let message = "alert.view.generic.connection.message".localized()
    if let alert = mk_alertView, alert.message == message {
      switch alert.actionType {
      case .dismiss:
        return
      default:
        break
      }
    }
    dismissCurrentAlertView()
    let alertView = AlertView()
    mk_alertView = alertView
    alertView.show(message: "alert.view.generic.connection.message".localized(),
                   type: .dismiss, in: view, onDismiss: { [weak self] in
                    self?.mk_alertView = nil
    })
  }
  
  private func showGenericRetryingAlertView(retryHandler: DefaultHandler? = nil) {
    dismissCurrentAlertView()
    let alertView = AlertView()
    mk_alertView = alertView
    alertView.show(message: "alert.view.generic.connection.message".localized(),
                   type: .retryInternetRequest(handler: retryHandler ?? {}), in: view, onDismiss: { [weak self] in
                    self?.mk_alertView = nil
    })
  }
  
  private func dismissCurrentAlertView() {
    mk_alertView?.dismissHandler = nil
    mk_alertView?.dismiss()
  }
}
