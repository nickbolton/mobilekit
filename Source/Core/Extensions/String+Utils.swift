//
//  String+Utils.swift
//  ShowTime
//
//  Created by Nick Bolton on 8/17/16.
//  Copyright © 2020 Pixelbleed LLC. All rights reserved.
//
import UIKit

private let characterEntities : [ String : Character ] = [
  // XML predefined entities:
  "&quot;"    : "\"",
  "&amp;"     : "&",
  "&apos;"    : "'",
  "&lt;"      : "<",
  "&gt;"      : ">",
  
  // HTML character entity references:
  "&nbsp;"    : "\u{00a0}",
  // ...
  "&diams;"   : "♦",
]

extension String {
  public var trimmed: String { return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
  public var length: Int { return count }

  public var properName: String {
    guard count > 0 else { return self }
    guard count > 1 else { return uppercased() }

    func mapFunc(_ substr: Substring) -> String {
      let string = String(substr)
      guard string.count > 1 else {
        return string.uppercased()
      }
      return "\(String(string[string.startIndex]).uppercased())\(String(string.substring(from: 1)).lowercased())"
    }
    return split(separator: " ").map(mapFunc).joined(separator: " ").split(separator: "-").map(mapFunc).joined(separator: "-")
  }

  public var wordCount: Int {
    let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
    let components = components(separatedBy: chararacterSet)
    return components.filter({ !$0.isEmpty }).count
  }
  
  public func textSize(using font: UIFont, withBounds: CGSize = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))) -> CGSize {
    
    let options = NSStringDrawingOptions.usesLineFragmentOrigin.union(.usesFontLeading)
    let rect = self.boundingRect(with: withBounds,
                                 options: options,
                                 attributes: [NSAttributedString.Key.font : font],
                                 context: nil)
    
    let width = ceil(rect.width)
    let height = ceil(rect.height)
    
    return CGSize(width: width, height: height)
  }
  
  public var stringByDecodingHTMLEntities : String {
    
    // ===== Utility functions =====
    
    // Convert the number in the string to the corresponding
    // Unicode character, e.g.
    //    decodeNumeric("64", 10)   --> "@"
    //    decodeNumeric("20ac", 16) --> "€"
    func decodeNumeric(_ string : String, base : Int) -> Character? {
      guard let code = UInt32(string, radix: base),
            let uniScalar = UnicodeScalar(code) else { return nil }
      return Character(uniScalar)
    }
    
    // Decode the HTML character entity to the corresponding
    // Unicode character, return `nil` for invalid input.
    //     decode("&#64;")    --> "@"
    //     decode("&#x20ac;") --> "€"
    //     decode("&lt;")     --> "<"
    //     decode("&foo;")    --> nil
    func decode(_ entity : String) -> Character? {
      if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
        return decodeNumeric(entity.substring(from: 3), base: 16)
      } else if entity.hasPrefix("&#") {
        return decodeNumeric(entity.substring(from: 2), base: 10)
      } else {
        return characterEntities[entity]
      }
    }
    
    // ===== Method starts here =====
    
    var result = ""
    var position = startIndex
    
    // Find the next '&' and copy the characters preceding it to `result`:
    while let ampRange = self.range(of: "&", range: position ..< endIndex) {
      result.append(String(self[position ..< ampRange.lowerBound]))
      position = ampRange.lowerBound
      
      // Find the next ';' and copy everything from '&' to ';' into `entity`
      if let semiRange = self.range(of: ";", range: position ..< endIndex) {
        let entity = String(self[position ..< semiRange.upperBound])
        position = semiRange.upperBound
        
        if let decoded = decode(entity) {
          // Replace by decoded character:
          result.append(decoded)
        } else {
          // Invalid entity, copy verbatim:
          result.append(entity)
        }
      } else {
        // No matching ';'.
        break
      }
    }
    // Copy remaining characters to `result`:
    result.append(String(self[position ..< endIndex]))
    return result
  }
  
  public func isValidEmailAddress(strict: Bool = true) ->Bool{
    let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    let laxString = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
    let emailRegex = strict ? stricterFilterString : laxString
    let emailTest:NSPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: self)
  }
  
  public var isValidHttpURL: Bool {
    let regEx = "((https|http)://)?((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
    return predicate.evaluate(with: self)
  }

  func index(from: Int) -> Index {
    return self.index(startIndex, offsetBy: from)
  }

  func substring(from: Int) -> String {
    let fromIndex = index(from: from)
    return String(self[fromIndex...])
  }

  func substring(to: Int) -> String {
    let toIndex = index(from: to)
    return String(self[..<toIndex])
  }

  func substring(with r: Range<Int>) -> String {
    let startIndex = index(from: r.lowerBound)
    let endIndex = index(from: r.upperBound)
    return String(self[startIndex..<endIndex])
  }
}
