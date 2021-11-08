//
//  Interpolate.swift
//  MobileKit
//
//  Created by Nick Bolton on 5/8/19.
//  Copyright © 2019 Pixelbleed LLC. All rights reserved.
//

import Foundation

public struct Interpolate {
  
  static public func discreteValues<T>(_ values: [T], progress: Double) -> T? {
    if (values.count <= 0) {
      return nil
    }
    
    var index = lround((progress * Double(values.count)) - 0.5)
    index = min(values.count - 1, max(0, index))
    return values[index]
  }
  
  static public func value(start: CGFloat, end: CGFloat, progress: Double) -> CGFloat {
    return start * CGFloat(1.0 - progress) + end * CGFloat(progress)
  }

  static public func value(start: Float, end: Float, progress: Double) -> Float {
    return start * Float(1.0 - progress) + end * Float(progress)
  }

  static public func value(start: Int, end: Int, progress: Double) -> Int {
    return Int(round(Float(start) * Float(1.0 - progress) + Float(end) * Float(progress)))
  }

  static public func value(start: UInt8, end: UInt8, progress: Double) -> UInt8 {
    return UInt8(round(Float(start) * Float(1.0 - progress) + Float(end) * Float(progress)))
  }

  static public func value(start: UInt16, end: UInt16, progress: Double) -> UInt16 {
    return UInt16(round(Float(start) * Float(1.0 - progress) + Float(end) * Float(progress)))
  }

  static public func value(start: UInt32, end: UInt32, progress: Double) -> UInt32 {
    return UInt32(round(Float(start) * Float(1.0 - progress) + Float(end) * Float(progress)))
  }

  static public func value(start: Int8, end: Int8, progress: Double) -> Int8 {
    return Int8(round(Float(start) * Float(1.0 - progress) + Float(end) * Float(progress)))
  }

  static public func value(start: Int16, end: Int16, progress: Double) -> Int16 {
    return Int16(round(Float(start) * Float(1.0 - progress) + Float(end) * Float(progress)))
  }

  static public func value(start: Int32, end: Int32, progress: Double) -> Int32 {
    return Int32(round(Float(start) * Float(1.0 - progress) + Float(end) * Float(progress)))
  }

  static public func value(start: CGPoint, end: CGPoint, progress: Double) -> CGPoint {
    let x = value(start: start.x, end: end.x, progress: progress)
    let y = value(start: start.y, end: end.y, progress: progress)
    return CGPoint(x: x, y: y)
  }
  
  static public func value(start: CGSize, end: CGSize, progress: Double) -> CGSize {
    let w = value(start: start.width, end: end.width, progress: progress)
    let h = value(start: start.height, end: end.height, progress: progress)
    return CGSize(width: w, height: h)
  }
  
  static public func value(start: CGRect, end: CGRect, progress: Double) -> CGRect {
    let origin = value(start: start.origin, end: end.origin, progress: progress)
    let size = value(start: start.size, end: end.size, progress: progress)
    return CGRect(origin: origin, size: size)
  }
  
  static public func value(start: CGVector, end: CGVector, progress: Double) -> CGVector {
    let dx = value(start: start.dx, end: end.dx, progress: progress)
    let dy = value(start: start.dy, end: end.dy, progress: progress)
    return CGVector(dx: dx, dy: dy)
  }
  
  static public func value(start: UIOffset, end: UIOffset, progress: Double) -> UIOffset {
    let h = value(start: start.horizontal, end: end.horizontal, progress: progress)
    let v = value(start: start.vertical, end: end.vertical, progress: progress)
    return UIOffset(horizontal: h, vertical: v)
  }
  
  static public func value(start: CGAffineTransform, end: CGAffineTransform, progress: Double) -> CGAffineTransform {
    let a = value(start: start.a, end: end.a, progress: progress)
    let b = value(start: start.b, end: end.b, progress: progress)
    let c = value(start: start.c, end: end.c, progress: progress)
    let d = value(start: start.d, end: end.d, progress: progress)
    let tx = value(start: start.tx, end: end.tx, progress: progress)
    let ty = value(start: start.ty, end: end.ty, progress: progress)
    return CGAffineTransform(a: a, b: b, c: c, d: d, tx: tx, ty: ty)
  }
  
  static public func value(start: UIEdgeInsets, end: UIEdgeInsets, progress: Double) -> UIEdgeInsets {
    let t = value(start: start.top, end: end.top, progress: progress)
    let b = value(start: start.bottom, end: end.bottom, progress: progress)
    let l = value(start: start.left, end: end.left, progress: progress)
    let r = value(start: start.right, end: end.right, progress: progress)
    return UIEdgeInsets(top: t, left: l, bottom: b, right: r)
  }
  
  static public func value(start: UIColor, end: UIColor, progress: Double) -> UIColor {
    var startHue: CGFloat = 0.0
    var startBrightness: CGFloat = 0.0
    var startSaturation: CGFloat = 0.0
    var startHSBAlpha: CGFloat = 0.0
    var endHue: CGFloat = 0.0
    var endBrightness: CGFloat = 0.0
    var endSaturation: CGFloat = 0.0
    var endHSBAlpha: CGFloat = 0.0
    var isHSBColorSpace = start.getHue(&startHue, saturation: &startSaturation, brightness: &startBrightness, alpha: &startHSBAlpha)
    isHSBColorSpace = isHSBColorSpace && end.getHue(&endHue, saturation: &endSaturation, brightness: &endBrightness, alpha: &endHSBAlpha)
    
    if isHSBColorSpace {
      let hue = value(start: startHue, end: endHue, progress: progress)
      let saturation = value(start: startSaturation, end: endSaturation, progress: progress)
      let brightness = value(start: startBrightness, end: endBrightness, progress: progress)
      let alpha = value(start: startHSBAlpha, end: endHSBAlpha, progress: progress)
      return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    var startRed: CGFloat = 0.0
    var startGreen: CGFloat = 0.0
    var startBlue: CGFloat = 0.0
    var startRGBAlpha: CGFloat = 0.0
    var endRed: CGFloat = 0.0
    var endGreen: CGFloat = 0.0
    var endBlue: CGFloat = 0.0
    var endRGBAlpha: CGFloat = 0.0
    
    var isRGBColorSpace = start.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startRGBAlpha)
    isRGBColorSpace = isRGBColorSpace && end.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endRGBAlpha)
    
    if isRGBColorSpace {
      let red = value(start: startRed, end: endRed, progress: progress)
      let green = value(start: startGreen, end: endGreen, progress: progress)
      let blue = value(start: startBlue, end: endBlue, progress: progress)
      let alpha = value(start: startRGBAlpha, end: endRGBAlpha, progress: progress)
      return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    var startWhite: CGFloat = 0.0
    var startGrayscaleAlpha: CGFloat = 0.0
    var endWhite: CGFloat = 0.0
    var endGrayscaleAlpha: CGFloat = 0.0
    var isGrayscaleColorSpace = start.getWhite(&startWhite, alpha: &startGrayscaleAlpha)
    isGrayscaleColorSpace = isGrayscaleColorSpace && end.getWhite(&endWhite, alpha: &endGrayscaleAlpha)
    if isGrayscaleColorSpace {
      let white = value(start: startWhite, end: endWhite, progress: progress)
      let alpha = value(start: startGrayscaleAlpha, end: endGrayscaleAlpha, progress: progress)
      return UIColor(white: white, alpha: alpha)
    }
    
    assert(false, "Cannot interpolate between two UIColors in different color spaces.")
    return start
  }
}
