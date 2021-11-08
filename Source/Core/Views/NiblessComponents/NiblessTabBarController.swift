//
//  NiblessTabBarController.swift
//  MobileKit
//
//  Created by Nick Bolton on 12/20/19.
//

import UIKit
import Reachability

open class NiblessTabBarController: UITabBarController {
  
  public var firstAppearance: Bool { return appearanceCount <= 1 }
  private(set) public var appearanceCount = 0
  private(set) public var hasAppeared = false
  private(set) public var isAppearing = false

  public var currentViewController: UIViewController? {
    guard
      let viewControllers = viewControllers,
      selectedIndex >= 0,
      selectedIndex < viewControllers.count
    else { return nil }
    return viewControllers[selectedIndex]
  }
  
  public var appContext = AppContext.shared
  
  public var shouldMonitoringReachability = false
  private (set) public var reachability = Reachability()
  
  open override var preferredStatusBarStyle: UIStatusBarStyle {
    return ThemeManager.shared.currentTheme().statusBarStyle
  }

  public init() {
    super.init(nibName: nil, bundle: nil)
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
    setNeedsStatusBarAppearanceUpdate()
    applyTheme()
    if shouldMonitoringReachability {
      startReachability()
    }
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    appearanceCount += 1
    isAppearing = true
    super.viewDidAppear(animated)
    hasAppeared = true
  }
  
  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidAppear(animated)
    isAppearing = false
    stopReachability()
  }
  
  @objc open func themeChanged() {
    applyTheme()
  }
  
  open func applyTheme() {
    view.walkHierarchyAndApplyTheme()
  }
  
  @objc open func applicationWillEnterForeground(noti: NSNotification) {
    if shouldMonitoringReachability {
      startReachability()
    }
  }
  
  @objc open func applicationDidEnterBackground(noti: NSNotification) {
    stopReachability()
  }
  
  @objc open func applicationWillResignActive(noti: NSNotification) {
    
  }
  
  @objc open func applicationDidBecomeActive(noti: NSNotification) {
    
  }
  
  @objc open func applicationWillTerminate(noti: NSNotification) {
    
  }
  
  @objc open func keyboardWillShow(noti: NSNotification) {
    
    guard let userInfo = noti.userInfo else {
      return
    }
    
    guard let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
      return
    }
    
    guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
      return
    }
    
    guard let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      return
    }
    
    let translation = -frameValue.cgRectValue.height
    let curve = UIView.AnimationOptions(rawValue: curveValue)
    
    keyboardWillShow(userInfo: userInfo, curve: curve, duration: duration, translation: translation)
  }
  
  @objc open func keyboardWillHide(noti: NSNotification) {
    
    if isAppearing {
      
      guard let userInfo = noti.userInfo else {
        return
      }
      
      guard let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
        return
      }
      
      guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
        return
      }
      
      guard let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
        return
      }
      
      let curve = UIView.AnimationOptions(rawValue: curveValue)
      let translation = frameValue.cgRectValue.height
      
      keyboardWillHide(userInfo: userInfo, curve: curve, duration: duration, translation: translation)
    }
  }
  
  open func keyboardWillShow(userInfo: [AnyHashable : Any]?, curve: UIView.AnimationOptions, duration: TimeInterval, translation: CGFloat) {
    // abstract
  }
  
  open func keyboardWillHide(userInfo: [AnyHashable : Any]?, curve: UIView.AnimationOptions, duration: TimeInterval, translation: CGFloat) {
    // abstract
  }
  
  open func reachabilityStatusChanged(_ reachability: Reachability) {
  }
}

public extension NiblessTabBarController {
  // MARK: Notification Observer Helpers
  
  func observeApplicationWillEnterForeground() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(applicationWillEnterForeground(noti:)),
                                           name: UIApplication.willEnterForegroundNotification,
                                           object: nil)
  }
  
  func unobserveApplicationWillEnterForeground() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIApplication.willEnterForegroundNotification,
                                              object: nil)
  }
  
  func observeApplicationDidEnterBackground() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(applicationDidEnterBackground(noti:)),
                                           name: UIApplication.didEnterBackgroundNotification,
                                           object: nil)
  }
  
  func unobserveApplicationDidEnterBackground() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIApplication.didEnterBackgroundNotification,
                                              object: nil)
  }
  
  func observeApplicationWillResignActive() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(applicationWillResignActive(noti:)),
                                           name: UIApplication.willResignActiveNotification,
                                           object: nil)
  }
  
  func unobserveApplicationWillResignActive() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIApplication.willResignActiveNotification,
                                              object: nil)
  }
  
  func observeApplicationDidBecomeActive() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(applicationDidBecomeActive(noti:)),
                                           name: UIApplication.didBecomeActiveNotification,
                                           object: nil)
  }
  
  func unobserveApplicationDidBecomeActive() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIApplication.didBecomeActiveNotification,
                                              object: nil)
  }
  
  func observeApplicationWillTerminate() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(applicationWillTerminate(noti:)),
                                           name: UIApplication.willTerminateNotification,
                                           object: nil)
  }
  
  func unobserveApplicationWillTerminate() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIApplication.willTerminateNotification,
                                              object: nil)
  }
  
  func observeKeyboardWillHide() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(noti:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  func unobserveKeyboardWillHide() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIResponder.keyboardWillHideNotification,
                                              object: nil)
  }
  
  func observeKeyboardWillShow() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(noti:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
  }
  
  func unobserveKeyboardWillShow() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIResponder.keyboardWillShowNotification,
                                              object: nil)
  }
}

extension NiblessTabBarController {
  // MARK: Reachability
  
  public func startReachability() {
    do {
      try reachability?.startNotifier()
      reachability?.whenReachable = { [weak self] reachability in
        DispatchQueue.main.async { self?.reachabilityStatusChanged(reachability) }
      }
      reachability?.whenUnreachable = { [weak self] reachability in
        DispatchQueue.main.async { self?.reachabilityStatusChanged(reachability) }
      }
    } catch {
      Logger.shared.error("\(error)")
    }
  }
  
  public func stopReachability() {
    reachability?.stopNotifier()
    reachability?.whenUnreachable = nil
    reachability?.whenReachable = nil
  }
}
