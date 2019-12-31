//
//  String+Emoji.swift
//  MobileKit
//
//  Created by Nick Bolton on 12/28/19.
//

import UIKit

public extension String {

  var hasAllEmoji: Bool {
    guard count > 0 else { return false }
    var result = true
    for char in self {
      result = result && String(char).hasEmoji
    }
    return result
  }
    
  var hasEmoji: Bool {
    guard count > 0 else { return false }
    let characterRender = UILabel(frame: .zero)
    characterRender.text = self
    characterRender.textColor = .black
    characterRender.backgroundColor = .black
    characterRender.sizeToFit()
    let rect = characterRender.bounds
    UIGraphicsBeginImageContextWithOptions(rect.size, true, 1)
    
    let contextSnap = UIGraphicsGetCurrentContext()!
    characterRender.layer.render(in: contextSnap)
    
    let capturedImageTmp = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    guard let capturedImage = capturedImageTmp else { return false }
    
    let imageRef = capturedImage.cgImage!
    let width = imageRef.width
    let height = imageRef.height
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    let bytesPerPixel = 4
    let bytesPerRow = bytesPerPixel * width
    let bitsPerComponent = 8
    let size = width * height * bytesPerPixel
    let rawData = calloc(size, MemoryLayout<CUnsignedChar>.stride).assumingMemoryBound(to: CUnsignedChar.self)
    
    guard let context = CGContext(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue) else { return false }
    
    context.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
    
    var result = false
    for offset in stride(from: 0, to: size, by: 4) {
      let r = rawData[offset]
      let g = rawData[offset + 1]
      let b = rawData[offset + 2]
      
      if (r > 0 || g > 0 || b > 0) {
        result = true
        break
      }
    }
    
    free(rawData)
    
    return result
  }
  
  public static func generateEmojis(length: Int, paragraphs: Int = 1, source: String? = nil) -> String {
    guard length > 0, paragraphs > 0 else { return "" }
    
    let emoticons = 0x1F600...0x1F64F
    let symbols = 0x1F300...0x1F5FF
    let transport = 0x1F680...0x1F6FF
    let flags = 0x1F1E6...0x1F1FF
    let miscSymbols = 0x2600...0x26FF
    let dingbats = 0x2700...0x27BF
    let variationSelectors = 0xFE00...0xFE0F
    let supplementalSymbols = 0x1F900...0x1F9FF

    let categories = [
      emoticons,
      symbols,
      transport,
      flags,
      miscSymbols,
      dingbats,
      variationSelectors,
      supplementalSymbols,
    ]
    
    let paragraphLength = length / paragraphs
    
    let invalidChar = "🛾︄"
    let invalidScalars = invalidChar.unicodeScalars

    var result = ""
    for _ in 0..<paragraphs {
      if result.count > 0 {
        result.append("\n")
      }
      for _ in 0..<paragraphLength {
        if let source = source, source.count > 0 {
          let index = Int.random(min: 0, max: source.count-1)
          let char = String(source[source.index(source.startIndex, offsetBy: index)])
          result.append(char)
        } else {
          let categoryIndex = Int.random(min: 0, max: categories.count-1)
          let range = categories[categoryIndex]
          var unicode = Int.random(in: range)
          var char = UnicodeScalar(unicode) != nil ? String(UnicodeScalar(unicode)!) : String(invalidScalars[invalidScalars.startIndex])
          result.append(char)
        }
      }
    }
    
    return result.trimmed
  }
}
