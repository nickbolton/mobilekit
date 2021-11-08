//
//  AnimationManager.swift
//  MobileKit
//
//  Created by Nick Bolton on 4/16/20.
//

import UIKit

public class AnimationManager {

  public let animators: [Animator]
  public let duration: TimeInterval

  public private (set) var isReversed = false

  public private (set) var transitionContext: TransitionContext!

  private var propertyAnimators: [UIViewPropertyAnimator]?
  private var dynamicAnimators: [UIDynamicAnimator]?

  private var displayLinkAnimator: DisplayLinkAnimator?

  public var useDisplayLinkAnimator = false

  public init(animators: [Animator], duration: TimeInterval) {
    self.animators = animators
    self.duration = duration
  }

  public func reverse(onComplete: DefaultHandler? = nil) {
    isReversed = true
    animate(onComplete: onComplete)
  }

  public func animate(onComplete: DefaultHandler? = nil) {

    if transitionContext == nil {
      transitionContext = TransitionContext(containerView: UIView())
      transitionContext.processedSetupViews.removeAll()
      transitionContext.animationDuration = duration
    }

    transitionContext.isReversed = isReversed

    for var anim in animators {
      anim.isReverse = isReversed
      anim.setupAnimation(context: self.transitionContext)
    }

    let completion = { [weak self] in self?.completeTransition(onComplete: onComplete) }

    if animators.count <= 0 {
      DispatchQueue.main.asyncAfter(timeInterval: duration) {
        completion()
      }
      return
    }

    if useDisplayLinkAnimator {
      animateUsingDisplayLink { _ in completion() }
    } else {
      animateUsingPropertyAnimator { completion() }
    }
  }

  public func completeInteractiveTransition() {
  }

  private func completeTransition(onComplete: DefaultHandler?) {
    transitionContext.isCompleted = true
    animators.forEach { $0.completeAnimation(context: transitionContext) }
    propertyAnimators = nil
    dynamicAnimators = nil
    transitionContext.processedSetupViews.removeAll()
    onComplete?()
  }

  @discardableResult
  private func animateUsingPropertyAnimator(onComplete: @escaping DefaultHandler) -> Int {
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

  private func animateUsingDisplayLink(onComplete: @escaping (Bool)->Void) {

      displayLinkAnimator = DisplayLinkAnimator()

      var totalDuration = duration

      // first pass determine the total duration
      for animator in animators {
          if animator.delay > 0.0 || animator.duration > 0.0 {
              totalDuration = max(animator.delay + animator.duration, totalDuration)
          }
      }

      // second pass set start/end times for animators that specify delay/duration params
      for var animator in animators {
          if animator.delay > 0.0 || animator.duration > 0.0 {
              let startingAt = animator.delay / totalDuration
              let endingAt = animator.startingAt + (animator.duration / totalDuration)
              animator.startingAt = startingAt
              animator.endingAt = endingAt
          }
      }

      displayLinkAnimator?.totalDuration = totalDuration

      for animator in animators {
        displayLinkAnimator?.registerAnimation(startingAt: isReversed ? animator.reverseStartingAt : animator.startingAt, endingAt: isReversed ? animator.reverseEndingAt : animator.endingAt, easing: animator.easing) { t in
              animator.performAnimations(at: t, context: self.transitionContext)
          }
      }

      displayLinkAnimator?.completion = onComplete
      displayLinkAnimator?.start()
  }
}
