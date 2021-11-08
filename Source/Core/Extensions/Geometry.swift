//
//  Geometry.swift
//  MobileKit
//
//  Created by Nick Bolton on 12/9/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

public extension CGFloat {
  
  var pointAligned: CGFloat { CGFloat(roundf(Float(self))) }
  var halfPointAligned: CGFloat { roundToPrecision(2.0) }
  var halfPointFloor: CGFloat { floorToPrecision(2.0) }
  var halfPointCeil: CGFloat { ceilToPrecision(2.0) }
  
  var isWithinEpsilon: Bool {
    let epsilon: CGFloat = 0.000001
    return abs(self) < epsilon
  }
  
  var truncatedErrorAlignedValue: CGFloat {
    let precision: CGFloat = 10000.0
    return floor(self * precision) / precision
  }
  
  func roundToPrecision(_ precision: CGFloat) -> CGFloat {
    if precision > 1.0 {
      return CGFloat(roundf(Float(self * precision))) / precision
    }
    return self
  }
  
  func floorToPrecision(_ precision: CGFloat) -> CGFloat {
    if precision > 1.0 {
      return floor(self * precision) / precision
    }
    return self
  }
  
  func ceilToPrecision(_ precision: CGFloat) -> CGFloat {
    if precision > 1.0 {
      return ceil(self * precision) / precision
    }
    return self
  }
  
  func scaled(by scale: CGFloat) -> CGFloat{
    self * scale
  }
  
  func normalize(by scale: CGFloat) -> CGFloat{
    guard scale != 0.0 else { return 0.0 }
    return self / scale
  }
  
  var truncatedSmallValue: CGFloat {
    let epsilon: CGFloat = 0.0001
    return abs(self) < epsilon ? 0.0 : self
  }
}

public extension CGPoint {
  
  func offset(by offset: CGFloat) -> CGPoint {
    CGPoint(x: x + offset, y: y + offset)
  }

  func offset(by delta: CGVector) -> CGPoint {
    offset(dx: delta.dx, dy: delta.dy)
  }

  func minusOffset(by delta: CGVector) -> CGPoint {
    offset(dx: -delta.dx, dy: -delta.dy)
  }

  func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
    CGPoint(x: x + dx, y: y + dy)
  }
  
  var pointAligned: CGPoint {
    CGPoint(x: x.pointAligned, y: y.pointAligned)
  }
  
  var halfPointAligned: CGPoint {
    CGPoint(x: x.halfPointAligned, y: y.halfPointAligned)
  }
  
  func ceilToPrecision(_ precision: CGFloat) -> CGPoint {
    CGPoint(x: x.roundToPrecision(precision), y: y.roundToPrecision(precision))
  }
  
  func roundToPrecision(_ precision: CGFloat) -> CGPoint {
    CGPoint(x: x.roundToPrecision(precision), y: y.roundToPrecision(precision))
  }
  
  func scaled(by scale: CGFloat) -> CGPoint {
    CGPoint(x: x.scaled(by: scale), y: y.scaled(by: scale))
  }
  
  func normalize(by scale: CGFloat) -> CGPoint {
    CGPoint(x: x.normalize(by: scale), y: y.normalize(by: scale))
  }
  
  func pathPoint(inRect rect: CGRect) -> CGPoint {
    CGPoint(x: rect.minX + (x * rect.width), y: rect.minY + (y * rect.height))
  }
  
  func pathPoint(inSize size: CGSize) -> CGPoint {
    pathPoint(inRect: CGRect(origin: .zero, size: size))
  }

  func difference(from p: CGPoint) -> CGVector {
    CGVector(dx: p.x - x, dy: p.y - y)
  }
  
  func distance(to p: CGPoint) -> CGFloat {
    let diff = difference(from: p)
    return sqrt((diff.dx * diff.dx) + (diff.dy * diff.dy))
  }
  
  var truncatedSmallValue: CGPoint {
    CGPoint(x: x.truncatedSmallValue, y: y.truncatedSmallValue)
  }

  func toVector() -> CGVector {
    CGVector(dx: x, dy: y)
  }
}

public extension CGSize {
  
  var epsilonBoundSize: CGSize {
    let epsilon: CGFloat = 0.1
    return CGSize(width: max(width, epsilon), height: max(height, epsilon))
  }
  
  func offset(by offset: CGFloat) -> CGSize {
    CGSize(width: width + offset, height: height + offset)
  }
  
  func offset(dx: CGFloat, dy: CGFloat) -> CGSize {
    CGSize(width: width + dx, height: height + dy)
  }
  
  var pointAligned: CGSize {
    CGSize(width: width.pointAligned, height: height.pointAligned)
  }
  
  var halfPointAligned: CGSize {
    CGSize(width: width.halfPointAligned, height: height.halfPointAligned)
  }
  
  var area: CGFloat {
    width * height
  }
  
  func ceilToPrecision(_ precision: CGFloat) -> CGSize {
    CGSize(width: width.roundToPrecision(precision), height: height.roundToPrecision(precision))
  }
  
  func roundToPrecision(_ precision: CGFloat) -> CGSize {
    CGSize(width: width.roundToPrecision(precision), height: height.roundToPrecision(precision))
  }
  
  func scaled(by scale: CGFloat) -> CGSize {
    CGSize(width: width.scaled(by: scale), height: height.scaled(by: scale))
  }

  func clamped(minValue: CGSize? = nil, maxValue: CGSize? = nil) -> CGSize {
    var result = self
    if let min = minValue {
      result.width = max(result.width, min.width)
      result.height = max(result.height, min.height)
    }
    if let max = maxValue {
      result.width = min(result.width, max.width)
      result.height = min(result.height, max.height)
    }
    return result
  }
  
  func normalize(by scale: CGFloat) -> CGSize {
    CGSize(width: width.normalize(by: scale), height: height.normalize(by: scale))
  }
  
  func aspectScaled(to size: CGSize) -> CGSize {
    guard width > 0.0 && height > 0.0 else { return self }
    var scaleFactor = size.height / height
    if abs(size.width - width) > abs(size.height - height) {
      scaleFactor = size.width / width
    }
    return scaled(by: scaleFactor).halfPointAligned
  }
  
  var rotated: CGSize { CGSize(width: height, height: width) }
  
  var truncatedSmallValue: CGSize {
    CGSize(width: width.truncatedSmallValue, height: height.truncatedSmallValue)
  }
}

public extension CGRect {
  
  var center: CGPoint { CGPoint(x: midX, y: midY) }
  
  var epsilonBoundSize: CGRect {
    CGRect(origin: origin, size: size.epsilonBoundSize)
  }
  
  var edgeInsets: UIEdgeInsets {
    UIEdgeInsets(top: minY,
                 left: minX,
                 bottom: maxY,
                 right: maxX)
  }
  
  var pointAligned: CGRect {
    CGRect(origin: origin.pointAligned, size: size.pointAligned)
  }
  
  var halfPointAligned: CGRect {
    CGRect(origin: origin.halfPointAligned, size: size.halfPointAligned)
  }
  
  func ceilToPrecision(_ precision: CGFloat) -> CGRect {
    CGRect(origin: origin.roundToPrecision(precision), size: size.roundToPrecision(precision))
  }
  
  func roundToPrecision(_ precision: CGFloat) -> CGRect {
    CGRect(origin: origin.roundToPrecision(precision), size: size.roundToPrecision(precision))
  }
  
  func scaled(by scale: CGFloat) -> CGRect {
    CGRect(origin: origin.scaled(by: scale), size: size.scaled(by: scale))
  }
  
  func normalize(by scale: CGFloat) -> CGRect {
    CGRect(origin: origin.normalize(by: scale), size: size.normalize(by: scale))
  }
  
  var rotated: CGRect {
    let center = CGPoint(x: midX, y: midY)
    return CGRect(x: center.x - (height / 2.0),
                  y: center.y - (width / 2.0),
                  width: height,
                  height: width)
  }
  
  private var smallSize: CGFloat { 0.0001 }
  
  func distance(to p: CGPoint) -> CGFloat {
    // first of all, we check if point is inside rect. If it is, distance is zero
    guard !contains(p) else { return 0.0 }
    let dx = max(max(minX - p.x, p.x - maxX), 0.0)
    let dy = max(max(minY - p.y, p.y - maxY), 0.0)
    return sqrt(dx*dx + dy*dy)
  }
  
  func distanceToClosetHorizontalEdge(point p: CGPoint) -> CGFloat {
    let leftRect = CGRect(x: minX, y: minY, width: smallSize, height: height)
    let midRect = CGRect(x: midX - (smallSize / 2.0), y: minY, width: smallSize, height: height)
    let rightRect = CGRect(x: maxX - smallSize, y: minY, width: smallSize, height: height)
    let leftDistance = leftRect.distance(to: p)
    let rightDistance = rightRect.distance(to: p)
    let midDistance = midRect.distance(to: p)
    return min(min(leftDistance, rightDistance), midDistance)
  }
  
  func distanceToClosetVerticalEdge(point p: CGPoint) -> CGFloat {
    let topRect = CGRect(x: minX, y: minY, width: width, height: smallSize)
    let midRect = CGRect(x: minX, y: midY - (smallSize / 2.0), width: width, height: smallSize)
    let bottomRect = CGRect(x: minX, y: maxX - smallSize, width: width, height: smallSize)
    let topDistance = topRect.distance(to: p)
    let bottomDistance = bottomRect.distance(to: p)
    let midDistance = midRect.distance(to: p)
    return min(min(topDistance, bottomDistance), midDistance)
  }
  
  func distanceToClosetEdge(point p: CGPoint) -> CGFloat {
    min(distanceToClosetHorizontalEdge(point: p), distanceToClosetVerticalEdge(point: p))
  }
  
  func vector(to rect: CGRect) -> CGVector {
    
    guard !intersects(rect) else { return .zero }
    
    let left = origin.x < rect.origin.x ? self : rect
    let right = rect.origin.x < origin.x ? self : rect;
    
    var dx = left.origin.x == right.origin.x ? 0 : right.origin.x - (left.origin.x + left.size.width)
    dx = max(dx, 0.0)
    
    let upper = origin.y < rect.origin.y ? self : rect
    let lower = rect.origin.y < origin.y ? self : rect
    
    var dy = upper.origin.y == lower.origin.y ? 0 : lower.origin.y - (upper.origin.y + upper.size.height)
    dy = max(dy, 0.0)
    
    return CGVector(dx: abs(dx), dy: abs(dy))
  }
  
  func distance(to rect: CGRect) -> CGFloat {
    let v = vector(to: rect)
    return sqrt(v.dx*v.dx + v.dy*v.dy)
  }
  
  var truncatedSmallValue: CGRect {
    CGRect(origin: origin.truncatedSmallValue, size: size.truncatedSmallValue)
  }

  func expanded(by size: CGSize) -> CGRect {
    CGRect(
      x: minX - (size.width / 2.0),
      y: minY - (size.height / 2.0),
      width: width + size.width,
      height: height + size.height
    )
  }

  func expanded(by size: CGFloat) -> CGRect {
    CGRect(
      x: minX - (size / 2.0),
      y: minY - (size / 2.0),
      width: width + size,
      height: height + size
    )
  }

  var verticalSnappingValues: [CGFloat] { [minY, maxY] }
  var horizontalSnappingValues: [CGFloat] { [minX, maxX] }
}

public extension UIEdgeInsets {
  
  var max: CGFloat {
    Swift.max(Swift.max(Swift.max(top, bottom), left), right)
  }
  
  var cgRect: CGRect {
    CGRect(x: left,
           y: top,
           width: right - left,
           height: bottom - top)
  }
  
  func scaled(by scale: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(
      top: top.scaled(by: scale),
      left: left.scaled(by: scale),
      bottom: bottom.scaled(by: scale),
      right: right.scaled(by: scale)
    )
  }
  
  func normalize(by scale: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(
      top: top.normalize(by: scale),
      left: left.normalize(by: scale),
      bottom: bottom.normalize(by: scale),
      right: right.normalize(by: scale)
    )
  }
}

public extension CGVector {

  func toPoint() -> CGPoint { CGPoint(x: dx, y: dy) }
  
  func scaled(by scale: CGFloat) -> CGVector {
    CGVector(dx: dx.scaled(by: scale), dy: dy.scaled(by: scale))
  }
  
  var truncatedSmallValue: CGVector {
    CGVector(dx: dx.truncatedSmallValue, dy: dy.truncatedSmallValue)
  }
}
