//
//  UInt32+Utils.swift
//  MobileKit
//
//  Created by Nick Bolton on 7/25/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

extension UInt32 {
  static public func random(start: UInt32 = 0, end: UInt32 = UInt32.max) -> UInt32 {
    var result = arc4random_uniform(end-start)
    result += start
    
    return result
  }
}

public extension Int {
  
  /// Returns a random Int point number between 0 and Int.max.
  static var random: Int {
    return Int.random(n: Int.max)
  }
  
  /// Random integer between 0 and n-1.
  ///
  /// - Parameter n:  Interval max
  /// - Returns:      Returns a random Int point number between 0 and n max
  static func random(n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
  }
  
  ///  Random integer between min and max
  ///
  /// - Parameters:
  ///   - min:    Interval minimun
  ///   - max:    Interval max
  /// - Returns:  Returns a random Int point number between 0 and n max
  static func random(min: Int, max: Int) -> Int {
    return Int.random(n: max - min + 1) + min
    
  }
}

public extension UInt {
  
  /// Returns a random Int point number between 0 and Int.max.
  static var random: UInt {
    return UInt.random(n: UInt.max)
  }
  
  /// Random integer between 0 and n-1.
  ///
  /// - Parameter n:  Interval max
  /// - Returns:      Returns a random Int point number between 0 and n max
  static func random(n: UInt) -> UInt {
    return UInt(arc4random_uniform(UInt32(n)))
  }
  
  ///  Random integer between min and max
  ///
  /// - Parameters:
  ///   - min:    Interval minimun
  ///   - max:    Interval max
  /// - Returns:  Returns a random Int point number between 0 and n max
  static func random(min: UInt, max: UInt) -> UInt {
    return UInt.random(n: max - min + 1) + min
    
  }
}

// MARK: Double Extension

public extension Double {
  
  /// Returns a random floating point number between 0.0 and 1.0, inclusive.
  static var random: Double {
    return Double(arc4random()) / 0xFFFFFFFF
  }
  
  /// Random double between 0 and n-1.
  ///
  /// - Parameter n:  Interval max
  /// - Returns:      Returns a random double point number between 0 and n max
  static func random(min: Double, max: Double) -> Double {
    return Double.random * (max - min) + min
  }
}

// MARK: Float Extension

public extension Float {
  
  /// Returns a random floating point number between 0.0 and 1.0, inclusive.
  static var random: Float {
    return Float(Double(arc4random()) / Double(0xFFFFFFFF))
  }
  
  /// Random float between 0 and n-1.
  ///
  /// - Parameter n:  Interval max
  /// - Returns:      Returns a random float point number between 0 and n max
  static func random(min: Float, max: Float) -> Float {
    return Float.random * (max - min) + min
  }
}

// MARK: CGFloat Extension

public extension CGFloat {
  
  /// Randomly returns either 1.0 or -1.0.
  static var randomSign: CGFloat {
    return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
  }
  
  /// Returns a random floating point number between 0.0 and 1.0, inclusive.
  static var random: CGFloat {
    return CGFloat(Float.random)
  }
  
  /// Random CGFloat between 0 and n-1.
  ///
  /// - Parameter n:  Interval max
  /// - Returns:      Returns a random CGFloat point number between 0 and n max
  static func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat.random * (max - min) + min
  }
}
