//
//  UIButton+Design.swift
//  Redbeard
//
//  Created by Nick Bolton on 3/18/19.
//  Copyright © 2019 Pixelbleed LLC. All rights reserved.
//

import UIKit

public extension UIButton {
  
  static let highlightedTextAlpha: CGFloat = 0.5
  
  func applyHighlightedTextStyle() {
    let textColor = titleColor(for: .normal) ?? .white
    setTitleColor(textColor.color(withAlpha: UIButton.highlightedTextAlpha), for: .highlighted)
  }
  
  func applyHighlightedTextStyle(_ style: TextStyle) {
    setAttributedTitle(style.attributedString, for: .normal)
    setAttributedTitle(style.applying(textAlpha: UIButton.highlightedTextAlpha).attributedString, for: .highlighted)
  }  
}
