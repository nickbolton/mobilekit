/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Reachability

open class NiblessViewController: UIViewController {
  
  public var firstAppearance: Bool { return appearanceCount <= 1 }
  private(set) public var appearanceCount = 0
  private(set) public var hasAppeared = false
  private(set) public var isAppearing = false
  
  public var shouldMonitoringReachability = false
  private (set) public var reachability = Reachability()
  
  public init() {
    super.init(nibName: nil, bundle: nil)
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

public extension NiblessViewController {
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

extension NiblessViewController {
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
