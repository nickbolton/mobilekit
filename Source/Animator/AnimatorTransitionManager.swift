//
//  AnimatorTransitionManager.swift
//  Bedrock
//
//  Created by Nick Bolton on 3/28/18.
//  Copyright © 2018 Bedrock. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
public protocol TransitionAnimatable: class {
  var viewController: UIViewController! { get }
  var userInfo: Any? { get }
  var targetChildTransitionAnimatable: TransitionAnimatable? { get }
  func overridingTransitionAnimatable(with context: TransitionContext) -> TransitionAnimatable?
  func setupTransition(with context: TransitionContext, delay: inout TimeInterval)
  func transition(with context: TransitionContext, at time: TimeInterval)
  func finishTransition(with context: TransitionContext)
  func cancelTransition(with context: TransitionContext)
  func uiElement(forKey: String, with context: TransitionContext) -> UIView?
  func uiElements() -> [UIView]
  func animators(with context: TransitionContext) -> [Animator]
}

@available(iOS 10.0, *)
extension TransitionAnimatable {
  public var viewController: UIViewController! { return UIViewController() }
  public var isInteractive: Bool { return false }
  public var userInfo: Any? { nil }
  public var targetChildTransitionAnimatable: TransitionAnimatable? { return nil }
  public func overridingTransitionAnimatable(with context: TransitionContext) -> TransitionAnimatable? { return nil }
  public func setupTransition(with context: TransitionContext, delay: inout TimeInterval) { }
  public func transition(with context: TransitionContext, at time: TimeInterval) { }
  public func finishTransition(with context: TransitionContext) { }
  public func cancelTransition(with context: TransitionContext) { }
  public func uiElement(forKey: String, with context: TransitionContext) -> UIView? { return nil }
  public func uiElements() -> [UIView] { [] }
}

@available(iOS 10.0, *)
extension TransitionAnimatable where Self: UIViewController {
  public var viewController: UIViewController! { return self }
}

@available(iOS 10.0, *)
private class DefaultTransitionAnimatable: TransitionAnimatable {
  func animators(with context: TransitionContext) -> [Animator] { return [] }
}

@available(iOS 10.0, *)
public class TransitionContext: AnimationContext {
  public weak var transitionManager: AnimatorTransitionManager?
  public var from: TransitionAnimatable { didSet { transitionKey = buildTransitionKey() } }
  public var to: TransitionAnimatable { didSet { transitionKey = buildTransitionKey() } }
  public var selectedIndexPath: IndexPath?
  public var isPresenting: Bool { return !isReversed }
  public var transitionKey = ""
  public var resolvedFrom: TransitionAnimatable { return from.overridingTransitionAnimatable(with: self) ?? from }
  public var resolvedTo: TransitionAnimatable { return to.overridingTransitionAnimatable(with: self) ?? to }
  public override var isReversed: Bool { didSet { transitionKey = buildTransitionKey() } }
  
  required public init(transitionManager: AnimatorTransitionManager?, from: TransitionAnimatable, to: TransitionAnimatable, containerView: UIView, isPresenting: Bool) {
    self.transitionManager = transitionManager
    self.from = from
    self.to = to
    super.init(containerView: containerView)
    self.isReversed = !isPresenting
    transitionKey = buildTransitionKey()
  }
  
  required public init(containerView: UIView) {
    self.from = DefaultTransitionAnimatable()
    self.to = DefaultTransitionAnimatable()
    super.init(containerView: containerView)
  }
  
  private func buildTransitionKey() -> String {
    let fromString = NSStringFromClass(type(of: from.viewController))
    let fromStringWithAddress = String(format: "%@:%p", fromString, from.viewController)
    let toString = NSStringFromClass(type(of: to.viewController))
    let toStringWithAddress = String(format: "%@:%p", toString, to.viewController)
    let result = isReversed ? "\(toStringWithAddress)->\(fromStringWithAddress)" : "\(fromStringWithAddress)->\(toStringWithAddress)"
    return result
  }
}

fileprivate struct AssociatedKeys {
  static var transitionManager: UInt8 = 0
}

@available(iOS 10.0, *)
public extension UIViewController {
  var animatorTransitionManager: AnimatorTransitionManager? {
    get { return objc_getAssociatedObject(self, &AssociatedKeys.transitionManager) as? AnimatorTransitionManager }
    set { objc_setAssociatedObject(self, &AssociatedKeys.transitionManager, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
}

@available(iOS 10.0, *)
public class AnimatorTransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
  
  public var selectedIndexPath: IndexPath? {
    get { return transitionContext.selectedIndexPath }
    set { transitionContext.selectedIndexPath = newValue }
  }

  public var interactiveCompletionDuration: TimeInterval = 0.0
  public var animationDuration: TimeInterval = 0.3
  private (set) public var transitionContext = TransitionContext(transitionManager: nil, from: DefaultTransitionAnimatable(), to: DefaultTransitionAnimatable(), containerView: UIView(), isPresenting: false)
  
  public var animators = [Animator]()
  private var isPresenting = true
  private var allAnimatorsDict = [String: [Animator]]()
  public var isRevealing = true
  public var isInteractive = false
  public var isVerbose = false
  public var isSetupOnly = false
  public var isCancelled = false

  public var completionBlock: DefaultHandler?
  
  private func animators(for key: String) -> [Animator] {
    return allAnimatorsDict[key] ?? []
  }
  
  public var isCompletionDisabled = false // for debugging purposes only
  
  private var propertyAnimators: [UIViewPropertyAnimator]?
  private var dynamicAnimators: [UIDynamicAnimator]?

  public weak var chainingNavigationDelegate: UINavigationControllerDelegate?
  
  public func cancelAnimations() {
    cancel()
  }
  
  public func pauseAnimations() {
  }
  
  public func resumeAnimations() {
  }
  
  public override func startInteractiveTransition(_ contextTransitioning: UIViewControllerContextTransitioning) {
    super.startInteractiveTransition(contextTransitioning)
    if isInteractive {
      doAnimation(using: contextTransitioning)
    }
  }
  
  // MARK: UIViewControllerAnimatedTransitioning Conformance
  
  public func animateTransition(using contextTransitioning: UIViewControllerContextTransitioning) {
    if !isInteractive {
      doAnimation(using: contextTransitioning)
    }
  }
  
  public func animate(from: TransitionAnimatable,
                      to: TransitionAnimatable,
                      duration: TimeInterval,
                      onComplete: DefaultHandler? = nil) {
    completionBlock = onComplete
    let toView = to.viewController.view!
    let fromView = from.viewController.view!
    doAnimation(containerView: fromView, fromVC: from, toVC: to, fromView: fromView, toView: toView, container: toView, duration: duration)
  }
  
  public private (set) weak var contextTransitioning: UIViewControllerContextTransitioning?
  
  private func doAnimation(using contextTransitioning: UIViewControllerContextTransitioning) {
    self.contextTransitioning = contextTransitioning
    let container = contextTransitioning.containerView
    
    let toViewController = contextTransitioning.viewController(forKey: .to)!
    let fromViewController = contextTransitioning.viewController(forKey: .from)!
    let toView = contextTransitioning.view(forKey: .to)!
    let fromView = contextTransitioning.view(forKey: .from)!

    var proposedFromVC = fromViewController as? TransitionAnimatable
    if let targetFromVC = proposedFromVC?.targetChildTransitionAnimatable {
      proposedFromVC = targetFromVC
    }
    
    var proposedToVC = toViewController as? TransitionAnimatable
    if let targetToVC = proposedToVC?.targetChildTransitionAnimatable {
      proposedToVC = targetToVC
    }
    
    guard proposedFromVC != nil, proposedToVC != nil else {
      contextTransitioning.completeTransition(false)
      Logger.shared.warning("both source and target VCs need to conform to TransitionAnimatable")
      return
    }
    
    let fromVC = proposedFromVC!
    let toVC = proposedToVC!
    
    if isPresenting {
      if isRevealing {
        container.insertSubview(toView, at: 0)
      } else {
        container.addSubview(toView)
      }
    } else {
      if isRevealing {
        container.addSubview(toView)
      } else {
        container.insertSubview(toView, at: 0)
      }
    }
    
    toView.transform = .identity
    toView.frame = contextTransitioning.finalFrame(for: toViewController)
    
    if isPresenting {
      toView.layoutIfNeeded() // force a view hierarchy layout
    }
    
    toView.isHidden = isRevealing
    
    let duration = self.transitionDuration(using: contextTransitioning)
    doAnimation(containerView: container, fromVC: fromVC, toVC: toVC, fromView: fromView, toView: toView, container: container, duration: duration)
  }
  
  private func doAnimation(containerView: UIView,
                           fromVC: TransitionAnimatable,
                           toVC: TransitionAnimatable,
                           fromView: UIView,
                           toView: UIView,
                           container: UIView,
                           duration: TimeInterval) {
    
    transitionContext.processedSetupViews.removeAll()
    transitionContext.transitionManager = self
    transitionContext.isReversed = !isPresenting
    transitionContext.from = fromVC
    transitionContext.to = toVC
    transitionContext.containerView = container
    transitionContext.animationDuration = duration
    transitionContext.selectedIndexPath = selectedIndexPath
    
    if isVerbose {
      Logger.shared.debug("resolved from vc: \(transitionContext.from)")
      Logger.shared.debug("resolved to vc: \(transitionContext.to)")
      Logger.shared.debug("transitionKey: \(transitionContext.transitionKey)")
    }
    
    let fromTransitionAnimatable = transitionContext.resolvedFrom
    let toTransitionAnimatable = transitionContext.resolvedTo
    
    var animators = self.animators(for: transitionContext.transitionKey)
    
    if isPresenting || animators.count <= 0 {
      animators = [Animator]()
      animators.append(contentsOf: fromTransitionAnimatable.animators(with: transitionContext))
      animators.append(contentsOf: toTransitionAnimatable.animators(with: transitionContext))
      animators.append(contentsOf: self.animators)
      allAnimatorsDict[transitionContext.transitionKey] = animators
    }
    
    animators = animators.filter { anim in
      (isPresenting && anim.directionMask.contains(.forward)) ||
        (!isPresenting && anim.directionMask.contains(.reverse))
    }
    
    for var anim in animators {
      anim.isReverse = !isPresenting
      anim.setupAnimation(context: self.transitionContext)
    }
    
    var fromSetupDelay: TimeInterval = 0.0
    var toSetupDelay: TimeInterval = 0.0
    fromTransitionAnimatable.setupTransition(with: self.transitionContext, delay: &fromSetupDelay)
    toTransitionAnimatable.setupTransition(with: self.transitionContext, delay: &toSetupDelay)
    let setupDelay: TimeInterval = max(fromSetupDelay, toSetupDelay)
    
    toView.isHidden = false
    
    let completion = { [weak self] isCompleted in self?.completeTransition(isCompleted) }
    
    if animators.count <= 0 {
      DispatchQueue.main.asyncAfter(timeInterval: duration) {
        completion(true)
      }
      return
    }
    
    guard !isSetupOnly else {
      return
    }
    
    if !isInteractive {
      UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    animateUsingPropertyAnimator(containerView: containerView, animators: animators, delay: setupDelay, duration: duration, from: fromTransitionAnimatable, to: toTransitionAnimatable) {
      if !self.isInteractive {
        UIApplication.shared.endIgnoringInteractionEvents()
      }
      completion(true)
    }
  }
  
  public func completeInteractiveTransition() {
  }
  
  private func completeTransition(_ isCompleted: Bool) {
    isInteractive = false
    guard !isCompletionDisabled else { return }
    transitionContext.isCompleted = !(contextTransitioning?.transitionWasCancelled ?? isCancelled)
    _ = animators(for: transitionContext.transitionKey).map { $0.completeAnimation(context: transitionContext) }
    
    let fromTransitionAnimatable = transitionContext.resolvedFrom
    let toTransitionAnimatable = transitionContext.resolvedTo
    
    if transitionContext.isCompleted {
      transitionContext.from.finishTransition(with: transitionContext)
      transitionContext.to.finishTransition(with: transitionContext)
      if fromTransitionAnimatable !== transitionContext.from {
        fromTransitionAnimatable.finishTransition(with: transitionContext)
      }
      if toTransitionAnimatable !== transitionContext.to {
        toTransitionAnimatable.finishTransition(with: transitionContext)
      }
    } else {
      transitionContext.from.cancelTransition(with: transitionContext)
      transitionContext.to.cancelTransition(with: transitionContext)
      if fromTransitionAnimatable !== transitionContext.from {
        fromTransitionAnimatable.cancelTransition(with: transitionContext)
      }
      if toTransitionAnimatable !== transitionContext.to {
        toTransitionAnimatable.cancelTransition(with: transitionContext)
      }
    }
    if !isPresenting {
      selectedIndexPath = nil
    }
    propertyAnimators = nil
    dynamicAnimators = nil
    transitionContext.processedSetupViews.removeAll()
    if (!isPresenting && transitionContext.isCompleted) || (isPresenting && !transitionContext.isCompleted) {
      allAnimatorsDict.removeValue(forKey: transitionContext.transitionKey)
    }
    contextTransitioning?.completeTransition(transitionContext.isCompleted)
    completionBlock?()
  }
  
  @discardableResult
  private func animateUsingPropertyAnimator(containerView: UIView, animators: [Animator], delay: TimeInterval, duration: TimeInterval, from: TransitionAnimatable, to: TransitionAnimatable, onComplete: @escaping DefaultHandler) -> Int {
    if delay > 0.0 {
      DispatchQueue.main.asyncAfter(timeInterval: delay) {
        self.animateUsingPropertyAnimator(containerView: containerView, animators: animators, duration: duration, from: from, to: to, onComplete: onComplete)
      }
    } else {
      return animateUsingPropertyAnimator(containerView: containerView, animators: animators, duration: duration, from: from, to: to, onComplete: onComplete)
    }
    return 0
  }
  
  @discardableResult
  private func animateUsingPropertyAnimator(containerView: UIView, animators: [Animator], duration: TimeInterval, from: TransitionAnimatable, to: TransitionAnimatable, onComplete: @escaping DefaultHandler) -> Int {
    
    var timingBuckets = [String: [Animator]]()
    for anim in animators {
      var array: [Animator] = timingBuckets[anim.easing.hashKey] ?? []
      array.append(anim)
      timingBuckets[anim.easing.hashKey] = array
    }
    
    var propertyAnimators = [UIViewPropertyAnimator]()
    var dynamicAnimators = [UIDynamicAnimator]()
    var remainingCompletionCount = timingBuckets.values.count
    
    for bucket in timingBuckets.values {
      guard let anim = bucket.first else { continue }
      let propertyAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: anim.easing.timingParameters)
      var propertyAnimatorCount = 0
      
      for anim in bucket.sorted { $0.order < $1.order } {
        if anim.dynamicBehaviors.count > 0 {

          if let referenceView = anim.allViews.first?.superview {
            let dynamicAnimator = UIDynamicAnimator(referenceView: referenceView)
            anim.dynamicBehaviors.forEach { b in
              dynamicAnimator.addBehavior(b)
            }

            DispatchQueue.main.asyncAfter(timeInterval: anim.duration) {
              remainingCompletionCount -= 1
              if remainingCompletionCount <= 0 {
                onComplete()
              }
            }
          }

        } else {
          propertyAnimatorCount += 1
          propertyAnimator.addAnimations({
            anim.performAnimations(context: self.transitionContext)
          }, delayFactor: CGFloat(anim.startingAt))
        }
      }

      if propertyAnimatorCount > 0 {
        propertyAnimator.addCompletion { position in
          remainingCompletionCount -= 1
          if remainingCompletionCount <= 0 {
            onComplete()
          }
        }

        propertyAnimator.startAnimation()

        propertyAnimators.append(propertyAnimator)
      }

    }
    
    self.propertyAnimators = propertyAnimators
    
    return timingBuckets.count
  }
    
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }
  
  // MARK: UIViewControllerTransitioningDelegate Conformance
  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    self.isPresenting = true
    return self
  }
  
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    self.isPresenting = false
    return self
  }
  
  public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if isInteractive {
      self.isPresenting = true
      return self
    }
    return nil
  }
  
  public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if isInteractive {
      self.isPresenting = false
      return self
    }
    return nil
  }
  
  // MARK: UINavigationControllerDelegate Conformance
  
  public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    self.isPresenting = operation == .push
    return self
  }
  
  public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return isInteractive ? self : nil
  }
  
  public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    chainingNavigationDelegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
  }
  
  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    chainingNavigationDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
  }
}
