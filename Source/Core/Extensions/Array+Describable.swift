//
//  Array+Describable.swift
//  MobileKit
//
//  Created by Nick Bolton on 12/9/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import Foundation

extension Array: Describable {

  public var describe: String {
    var result = ""
    for item in self {
      if result.count <= 0 {
        if let describable = item as? Describable {
          result += "[\(describable.describe)"
        }
      } else {
        if let describable = item as? Describable {
          result += ", \(describable.describe)"
        }
      }
    }
    result += "]"
    return result
  }
}
