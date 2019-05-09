//
//  UIView+TextConstraints.swift
//  MobileKit
//
//  Created by Nick Bolton on 3/18/18.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif

public extension NSLayoutConstraint {
  
  func applyHeight(for style: TextStyle, width: CGFloat = CGFloat.greatestFiniteMagnitude) {
    guard firstAttribute == .height else {
      Logger.shared.warning("applyHeight: wrong constraint type '\(firstAttribute)'")
      return
    }
    let boundBy = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let textFrame = style.textViewFrame(for: .label, boundBy: boundBy, usePreciseTextAlignments: false, containerSize: boundBy)
    constant = textFrame.height
  }
  
  func applyTopMargin(for style: TextStyle, width: CGFloat = CGFloat.greatestFiniteMagnitude, offset: CGFloat = 0.0) {
    guard firstAttribute == .top else {
      Logger.shared.warning("applyTopMargin: wrong constraint type '\(firstAttribute)'")
      return
    }
    let boundBy = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let metrics = TextMetricsCache.shared.textMetrics(for: style, textType: .label, boundBy: boundBy)
    constant = -metrics.textMargins.top + offset
  }
  
  func applyTopMargin(for style: TextStyle, to targetStyle: TextStyle, width: CGFloat = CGFloat.greatestFiniteMagnitude, offset: CGFloat = 0.0) {
    guard firstAttribute == .top else {
      Logger.shared.warning("applyTopMargin: wrong constraint type '\(firstAttribute)'")
      return
    }
    
    let boundBy = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let metrics = TextMetricsCache.shared.textMetrics(for: style, textType: .label, boundBy: boundBy)
    let targetMetrics = TextMetricsCache.shared.textMetrics(for: targetStyle, textType: .label, boundBy: boundBy)
    
    constant = -metrics.textMargins.top - targetMetrics.textMargins.bottom + offset
  }
  
  func applyBottomMargin(for style: TextStyle, width: CGFloat = CGFloat.greatestFiniteMagnitude, offset: CGFloat = 0.0) {
    guard firstAttribute == .bottom else {
      Logger.shared.warning("applyBottomMargin: wrong constraint type '\(firstAttribute)'")
      return
    }
    
    let boundBy = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let metrics = TextMetricsCache.shared.textMetrics(for: style, textType: .label, boundBy: boundBy)
    constant = metrics.textMargins.bottom + offset
  }
  
  func applyBottomMargin(for style: TextStyle, to targetStyle: TextStyle, width: CGFloat = CGFloat.greatestFiniteMagnitude, offset: CGFloat = 0.0) {
    guard firstAttribute == .bottom else {
      Logger.shared.warning("applyBottomMargin: wrong constraint type '\(firstAttribute)'")
      return
    }
    
    let boundBy = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let metrics = TextMetricsCache.shared.textMetrics(for: style, textType: .label, boundBy: boundBy)
    let targetMetrics = TextMetricsCache.shared.textMetrics(for: targetStyle, textType: .label, boundBy: boundBy)
    
    constant = metrics.textMargins.bottom + targetMetrics.textMargins.top + offset
  }
}
