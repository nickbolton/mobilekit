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
