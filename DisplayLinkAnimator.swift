//
//  DisplayLinkAnimator.swift
//  MobileKit
//
//  Created by Nick Bolton on 4/16/20.
//

import UIKit

@available(iOS 10.0, *)
public typealias AnimationClosure = ((_ percent: TimeInterval) -> Void)

@available(iOS 10.0, *)
public typealias AnimationCompletion = ((Bool) -> Void)

@available(iOS 10.0, *)
public class DisplayLinkAnimator: NSObject {

    var _totalDuration: TimeInterval = 0.0
    public var totalDuration: TimeInterval {
        get { return isSlowMotionEnabled ? 3.0 : _totalDuration }
        set { _totalDuration = newValue }
    }

    private var animations: Array<Animation> = []
    private var displayLink: CADisplayLink?
    private var startTime: TimeInterval = 0.0
    public var completion: AnimationCompletion?
    public var isTimingDebugEnabled = false
    public var isSlowMotionEnabled = false
    public var isInteractive = false
    private var lastInteractivePercent: CGFloat = 0.0
    private var isCanceling = false
    public var interactiveCompletionDuration: TimeInterval = 0.0
    private var didCallCompletionHandler = false

    public var isPaused: Bool { get { return displayLink?.isPaused ?? false } set { displayLink?.isPaused = isPaused } }

    public var isRunning: Bool {
        if let displayLink = displayLink {
            return !displayLink.isPaused
        }
        return false
    }

    static public func animator(with duration: TimeInterval) -> DisplayLinkAnimator {
        let animator = DisplayLinkAnimator()
        animator.totalDuration = duration
        return animator
    }

    public func registerAnimation(startingAt: TimeInterval = 0.0, endingAt: TimeInterval = 1.0, easing: Easing = Easing(.quadInOut), closure: @escaping AnimationClosure) {

        let animation = Animation(startTime: startingAt, endTime: endingAt, easing: easing, closure: closure)
        animations.append(animation)
    }

    public func start() {
        guard !isInteractive else { return }
        startTime = CACurrentMediaTime()
        isCanceling = false
        didCallCompletionHandler = false
        _setupDisplayLink()
    }

    public func cancel() {
        _tearDownDisplayLink()
    }

    public func completeInteractive() {
        guard isInteractive else { return }
        startTime = 0.0
        isCanceling = false
        _setupDisplayLink()
    }

    public func cancelInteractive() {
        guard isInteractive else { return }
        startTime = 0.0
        isCanceling = true
        _setupDisplayLink()
    }

    public func update(percent percentIn: CGFloat) {
        let percent = min(max(percentIn, 0.0), 1.0)
        isCanceling = false
        lastInteractivePercent = percent
        for animation in animations {
            animation.closure(TimeInterval(percent))
        }
    }

    private func _setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(_tickAnimation))
        displayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }

    private func _tearDownDisplayLink() {
        displayLink?.isPaused = true
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc internal func _tickAnimation() {
        guard let displayLink = displayLink else { return }
        guard !displayLink.isPaused else { return }

        var duration = totalDuration

        if interactiveCompletionDuration > 0.0 {
            duration = interactiveCompletionDuration
        }

        if startTime == 0.0 {
            var startingPercentComplete = TimeInterval(lastInteractivePercent)
            if isCanceling {
                startingPercentComplete = 1.0 - startingPercentComplete
            }
            startTime = displayLink.timestamp - (startingPercentComplete * duration)
        }

        let elapsedTime = displayLink.timestamp - startTime

        var time = duration > 0.0 ? (elapsedTime) / duration : 1.0
        time = max(time, 0.0)

        if isCanceling {
            time = 1.0 - time
        }

        let t1 = Date.timeIntervalSinceReferenceDate

        for animation in animations {
            let duration = animation.endTime - animation.startTime
            var animationTime = (time - animation.startTime) / duration
            animationTime = max(animationTime, 0.0)
            var percent: TimeInterval = 0.0
            if lastInteractivePercent > 0.0 {
                if isCanceling {
                    percent = animation.easing.solveForTime(animationTime)
                } else {
                    percent = animation.easing.inverseSolveForTime(animationTime)
                }
            } else {
                percent = animation.easing.solveForTime(animationTime)
            }
            animation.closure(percent)
        }

        let animationsElapsedTime = Date.timeIntervalSinceReferenceDate - t1
        if isTimingDebugEnabled {
            DispatchQueue.global().async { Logger.shared.debug("animation tick took: \(animationsElapsedTime) s") }
        }

        if #available(iOS 10.0, *) {
            if displayLink.timestamp + animationsElapsedTime > displayLink.targetTimestamp {
                DispatchQueue.global().async { Logger.shared.warning("animation tick took too long!! \(animationsElapsedTime)") }
            }
        }

        if (isCanceling && time <= 0.0) || (!isCanceling && elapsedTime >= totalDuration) {
            lastInteractivePercent = 0.0
            _tearDownDisplayLink()
            if !didCallCompletionHandler {
                didCallCompletionHandler = true
                completion?(!isCanceling)
            }
        }
    }
}

@available(iOS 10.0, *)
private struct Animation {
    var closure: AnimationClosure
    var startTime: TimeInterval = 0.0
    var endTime: TimeInterval = 0.0
    var easing: Easing

    init(startTime: TimeInterval, endTime: TimeInterval, easing: Easing, closure: @escaping AnimationClosure) {
        self.startTime = startTime
        self.endTime = endTime
        self.easing = easing
        self.closure = closure
    }
}
