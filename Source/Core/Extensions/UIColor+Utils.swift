//
//  UIColor+Utils.swift
//  MobileKit
//
//  Copyright © 2020 Pixelbleed LLC All rights reserved.
//

import UIKit

extension UIColor {
  
  public var alpha: CGFloat {
    var result: CGFloat = 0.0
    if getRed(nil, green: nil, blue: nil, alpha: &result) {
      return result
    }
    if getWhite(nil, alpha: &result) {
      return result
    }
    return 0.0
  }

  public var hex: Int32 {
    let (red, green, blue, _) = rbga
    return (Int32(red * 255.0) << 16) | (Int32(green * 255.0) << 8) | Int32(blue * 255.0)
  }

  public var rbga: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 0.0
    var white: CGFloat = 0.0

    if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      return (red, green, blue, alpha)
    }
    if getWhite(&white, alpha: &alpha) {
      return (white, white, white, alpha)
    }
    return (0.0, 0.0, 0.0, 0.0)
  }

  public var hexString: String {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 0.0
    
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    let hex = (Int32(red * 255.0) << 24) | (Int32(green * 255.0) << 16) | (Int32(blue * 255.0) << 8) | Int32(alpha * 255.0)
    let result = String(format: "%08x", hex)
    return result
  }
  
  public var brightnessFactor: CGFloat {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    getRed(&red, green: &green, blue: &blue, alpha: nil)
    
    red *= 255.0
    green *= 255.0
    blue *= 255.0
    
    return sqrt(
      (red * red * 0.241) +
        (green * green * 0.691) +
        (blue * blue * 0.068))
  }
  
  public convenience init(hex: Int32, alpha: CGFloat = 1.0) {
    let red = CGFloat((hex >> 16) & 0xFF)
    let green = CGFloat((hex >> 8) & 0xFF)
    let blue = CGFloat((hex) & 0xFF)
    
    self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
  }
  
  public convenience init(hexString: String, alpha: CGFloat = 1.0) {
    var colorString = hexString.replacingOccurrences(of: "#", with: "").uppercased()
    
    if (colorString.count == 0 || colorString.count == 5 || colorString.count == 7) {
      self.init(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: alpha)
      return
    } else if (colorString.count == 1 || colorString.count == 2) {
      colorString = "\(colorString)\(colorString)\(colorString)"
    }
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 1.0
    
    switch (colorString.count) {
    case 3: // #RGB
      red   = UIColor.colorComponent(from: colorString, start: 0, length: 1)
      green = UIColor.colorComponent(from: colorString, start: 1, length: 1)
      blue  = UIColor.colorComponent(from: colorString, start: 2, length: 1)
      break;
    case 4: // #RGBA
      red   = UIColor.colorComponent(from: colorString, start: 0, length: 1)
      green = UIColor.colorComponent(from: colorString, start: 1, length: 1)
      blue  = UIColor.colorComponent(from: colorString, start: 2, length: 1)
      alpha = UIColor.colorComponent(from: colorString, start: 3, length: 1)
      break;
    case 6: // #RRGGBB
      red   = UIColor.colorComponent(from: colorString, start: 0, length: 2)
      green = UIColor.colorComponent(from: colorString, start: 2, length: 2)
      blue  = UIColor.colorComponent(from: colorString, start: 4, length: 2)
      break;
    case 8: // #RRGGBBAA
      red   = UIColor.colorComponent(from: colorString, start: 0, length: 2)
      green = UIColor.colorComponent(from: colorString, start: 2, length: 2)
      blue  = UIColor.colorComponent(from: colorString, start: 4, length: 2)
      alpha = UIColor.colorComponent(from: colorString, start: 6, length: 2)
      break;
    default:
      break;
    }
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  private static func colorComponent(from: String, start: Int, length: Int) -> CGFloat {
    let range = from.index(from.startIndex, offsetBy: start)..<from.index(from.startIndex, offsetBy: start+length)
    let substring = String(from[range])
    let fullHex = length == 2 ? substring : "\(substring)\(substring)"
    var hexComponent: UInt64 = 0
    let scanner = Scanner(string: fullHex)
    scanner.scanHexInt64(&hexComponent)
    return CGFloat(hexComponent) / CGFloat(255.0)
  }
  
  public func color(withAlpha alpha: CGFloat) -> UIColor {
    var red: CGFloat = 0.0;
    var blue: CGFloat = 0.0;
    var green: CGFloat = 0.0;
    
    getRed(&red, green: &green, blue: &blue, alpha: nil)
    
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  static public func random() -> UIColor {
    let red =  CGFloat(UInt32.random(start: 0, end: 255))/CGFloat(255.0)
    let blue =  CGFloat(UInt32.random(start: 0, end: 255))/CGFloat(255.0)
    let green =  CGFloat(UInt32.random(start: 0, end: 255))/CGFloat(255.0)
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
  }
}
