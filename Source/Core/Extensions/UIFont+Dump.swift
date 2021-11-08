//
//  UIFont+Dump.swift
//  MobileKit
//
//  Created by Nick Bolton on 12/9/20.
//

import UIKit

extension UIFont {

  func dumpAvailableFonts() {
    for family in UIFont.familyNames {
      let names = UIFont.fontNames(forFamilyName: family)
      print("\(family) \(names)")
    }
  }
}
