//
//  Math.swift
//  Bedrock
//
//  Created by Nick Bolton on 10/7/16.
//  Copyright © 2016 Pixelbleed LLC All rights reserved.
//

public func clamp<T : Comparable>(_ value: T, min minValue: T, max maxValue: T) -> T {
    return min(max(value, minValue), maxValue)
}

public extension CGFloat {
  var inverse: CGFloat { return self != 0.0 ? 1.0 / self : 0.0 }

  /// Returns the value, scaled-and-shifted to the targetRange.
  /// If no target range is provided, we assume the unit range (0, 1)
  static func scaleAndShift(
    value: CGFloat,
    inRange: (min: CGFloat, max: CGFloat),
    toRange: (min: CGFloat, max: CGFloat) = (min: 0.0, max: 1.0)
    ) -> CGFloat {
    assert(inRange.max > inRange.min)
    assert(toRange.max > toRange.min)

    if value < inRange.min {
      return toRange.min
    } else if value > inRange.max {
      return toRange.max
    } else {
      let ratio = (value - inRange.min) / (inRange.max - inRange.min)
      return toRange.min + ratio * (toRange.max - toRange.min)
    }
  }
}

public extension Double {
  var inverse: Double { return self != 0.0 ? 1.0 / self : 0.0 }
}

public extension Float {
  var inverse: Float { return self != 0.0 ? 1.0 / self : 0.0 }
}

public extension CGPoint {
  func midpoint(with p: CGPoint) -> CGPoint {
    return CGPoint(x: (x + p.x) / 2.0, y: (y + p.y) / 2.0)
  }
}
