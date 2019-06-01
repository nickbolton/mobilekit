//
//  BaseCollectionViewLayout.swift
//  MobileKit
//
//  Created by Nick Bolton on 8/8/16.
//  Copyright © 2016 Pixelbleed LLC All rights reserved.
//

import UIKit

public protocol CollectionDataSourceProvider: class {
  func collectionItem(at indexPath: IndexPath) -> CollectionItem?
  var dataSource: [[CollectionItem]]? { get }
  func dataSourceArray(at section: Int) -> [CollectionItem]?
}

public extension CollectionDataSourceProvider {
  func dataSourceArray(at section: Int) -> [CollectionItem]? {
    guard let dataSource = self.dataSource else { return nil }
    var result: [CollectionItem]? = nil;
    if section < dataSource.count {
      result = dataSource[section]
    }
    return result
  }
  
  func collectionItem(at indexPath: IndexPath) -> CollectionItem? {
    if let sectionArray = dataSourceArray(at: indexPath.section) {
      if indexPath.row >= 0 && indexPath.row < sectionArray.count {
        return sectionArray[indexPath.row]
      }
    }
    return nil
  }
}

open class BaseCollectionViewLayout: UICollectionViewLayout {
  
  public let collectionViewCellKind = "collectionViewCellKind"
  public let collectionViewSupplimentaryKind = "collectionViewSupplimentaryKind"
  public let collectionViewDecorationKind = "collectionViewDecorationKind"
  
  public weak var viewController: UIViewController?
  public var minContentSize: CGSize = .zero
  public var isDebugging = false
  
  public var layoutInfo: Dictionary<String, Dictionary<IndexPath, UICollectionViewLayoutAttributes>>?
  public var oldLayoutInfo: Dictionary<String, Dictionary<IndexPath, UICollectionViewLayoutAttributes>>?
  
  public weak var dataSourceProvider: CollectionDataSourceProvider!
  
  public override init() {
    super.init()
    _commonInit()
  }
  
  @available(*, unavailable,
  message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
  )
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
  }

  private func _commonInit() {
    let screenBounds = UIScreen.main.bounds
    let orientation = UIDevice.current.orientation
    
    if (orientation.isLandscape) {
      minContentSize = CGSize(width: screenBounds.height, height: screenBounds.width)
    } else {
      minContentSize = screenBounds.size
    }
  }
  
  open func configure(attributes: inout UICollectionViewLayoutAttributes, with item: CollectionItem, at indexPath:IndexPath ) {
    attributes.transform3D = item.transform3D
    attributes.transform = item.transform
    attributes.alpha = item.alpha
    attributes.zIndex = item.zIndex
    attributes.isHidden = item.isHidden
    
    if (item.useCenter) {
      attributes.size = item.size
      attributes.center = item.center
    } else {
      attributes.frame = frame(for: item)
    }
    item.indexPath = indexPath
  }
  
  open func enumerateCollectionItems(_ itemHandler: (IndexPath, UICollectionViewLayoutAttributes, CollectionItem)->Void) {
    guard let collectionView = collectionView else { return }
    
    let sectionCount = collectionView.numberOfSections
    
    for section in 0..<sectionCount {
      let itemCount = collectionView.numberOfItems(inSection: section)
      for item in 0..<itemCount {
        let indexPath = IndexPath(item: item, section: section)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        if let item = dataSourceProvider?.collectionItem(at: indexPath) {
          itemHandler(indexPath, attributes, item)
        }
      }
    }
  }
  
  open override func prepare() {
    oldLayoutInfo = layoutInfo
    
    var newLayoutInfo = [String: Dictionary<IndexPath, UICollectionViewLayoutAttributes>]()
    var cellLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
    //        var supplimentaryLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
    //        var decorationLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
    
    enumerateCollectionItems { (ip, attr, item) in
      var attributes = attr
      configure(attributes: &attributes, with: item, at: ip)
      cellLayoutInfo[ip] = attributes
    }
    
    newLayoutInfo[collectionViewCellKind] = cellLayoutInfo
    //        newLayoutInfo[collectionViewSupplimentaryKind] = supplimentaryLayoutInfo
    //        newLayoutInfo[collectionViewDecorationKind] = decorationLayoutInfo
    
    if isDebugging {
      Logger.shared.debug("layoutInfo: \(newLayoutInfo)")
    }
    
    layoutInfo = newLayoutInfo
  }
  
  open func frameForItem(at indexPath: IndexPath) -> CGRect {
    guard let item = dataSourceProvider?.collectionItem(at: indexPath) else { return .zero }
    return frame(for: item)
  }
  
  open func frame(for item: CollectionItem) -> CGRect {
    var frame = CGRect.zero
    frame.origin = item.point
    frame.size = item.size
    return frame
  }
  
  open func shouldInclude(attributes: UICollectionViewLayoutAttributes, at indexPath: IndexPath, in rect: CGRect) -> Bool {
    return rect.intersects(attributes.frame)
  }
  
  open override func layoutAttributesForElements(in rect: CGRect) -> Array<UICollectionViewLayoutAttributes> {
    
    var result = [UICollectionViewLayoutAttributes]()
    
    if let layoutInfo = self.layoutInfo {
      for (_, value) in layoutInfo {
        for (indexPath, attributes) in value {
          if shouldInclude(attributes: attributes, at: indexPath, in: rect) {
            result.append(attributes)
          }
        }
      }
    }
    
    if (self.isDebugging) {
      Logger.shared.debug("atributes for rect \(rect): \(result)")
    }
    
    return result
  }
  
  open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if let layoutInfo = self.layoutInfo {
      if let dict = layoutInfo[collectionViewCellKind] {
        return dict[indexPath]
      }
    }
    return nil
  }
  
  public func layoutAttributesForSupplementaryView(of kind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if let layoutInfo = self.layoutInfo {
      if let dict = layoutInfo[kind] {
        return dict[indexPath]
      }
    }
    return nil
  }
  
  public func layoutAttributesForDecorationView(of kind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if let layoutInfo = self.layoutInfo {
      if let dict = layoutInfo[kind] {
        return dict[indexPath]
      }
    }
    return nil
  }
  
  public func maxPoint(of item: CollectionItem) -> CGPoint {
    
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    
    if (item.useCenter) {
      x = item.center.x + (item.size.width / 2.0)
      y = item.center.y + (item.size.height / 2.0)
    } else {
      x = item.point.x + item.size.width
      y = item.point.y + item.size.height
    }
    
    //    x += item.contentSizeOffset.width
    //    y += item.contentSizeOffset.height
    
    //    if (item.supplimentaryItem != nil) {
    //
    //        // resursion
    //
    //        CGPoint p = [self maxPointOfItem:item.supplimentaryItem]
    //
    //        x = MAX(x, p.x)
    //        y = MAX(y, p.y)
    //    }
    //
    //    if (item.decorationItem != nil) {
    //
    //        // resursion
    //
    //        CGPoint p = [self maxPointOfItem:item.decorationItem]
    //
    //        x = MAX(x, p.x)
    //        y = MAX(y, p.y)
    //    }
    
    return CGPoint(x: x, y: y)
  }
  
  open override var collectionViewContentSize: CGSize { return calculateContentSize() }
  
  open func calculateContentSize() -> CGSize {
    guard let dataSource = dataSourceProvider?.dataSource else { return minContentSize }
    
    var bottomMostPosition: CGFloat = 0.0
    var rightMostPosition: CGFloat = 0.0
    var sizeSet = false
    
    for items in dataSource {
      for item in items {
        
        sizeSet = true
        
        let p = maxPoint(of: item)
        
        rightMostPosition = max(rightMostPosition, p.x)
        bottomMostPosition = max(bottomMostPosition, p.y)
      }
    }
    
    var width = minContentSize.width
    var height = minContentSize.height
    
    if sizeSet {
      width = max(width, rightMostPosition)
      height = max(height, bottomMostPosition)
    } else {
      Logger.shared.warning("No items in datasource!")
    }
    
    let size = CGSize(width: width, height: height)
    if (self.isDebugging) {
      Logger.shared.debug("content size: \(size)")
    }
    
    return size
  }
  
  open override func initialLayoutAttributesForAppearingItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if let oldLayoutInfo = self.oldLayoutInfo {
      if let dict = oldLayoutInfo[collectionViewCellKind] {
        return dict[indexPath]
      }
    }
    return nil
  }
  
  open override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if let oldLayoutInfo = self.oldLayoutInfo {
      if let dict = oldLayoutInfo[elementKind] {
        return dict[indexPath]
      }
    }
    return nil
  }
  
  open override func finalLayoutAttributesForDisappearingItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if let layoutInfo = self.oldLayoutInfo {
      if let dict = layoutInfo[collectionViewCellKind] {
        return dict[indexPath]
      }
    }
    return nil
  }
  
  open override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if let layoutInfo = self.oldLayoutInfo {
      if let dict = layoutInfo[elementKind] {
        return dict[indexPath]
      }
    }
    return nil
  }
}
