//
//  GloballyCachingCollectionViewLayout.swift
//  MobileKit
//
//  Created by Nick Bolton on 5/9/19.
//  Copyright © 2019 Playboy Enterprises International, Inc. All rights reserved.
//

import UIKit

open class GloballyCachingCollectionViewLayout: BaseCollectionViewLayout {

  var globalCache = [String: [IndexPath: UICollectionViewLayoutAttributes]]()

  public func clearCache() {
    globalCache.removeAll()
  }

  public func clearCache(at section: Int) {
    guard let collectionView = collectionView, let dataSource = collectionView.dataSource else { return }
    let itemCount = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
    guard itemCount > 0, var dict = globalCache[collectionViewCellKind] else { return }
    for item in 0..<itemCount {
      dict.removeValue(forKey: IndexPath(item: item, section: section))
    }
    globalCache[collectionViewCellKind] = dict
  }

  open override func prepare() {
    oldLayoutInfo = layoutInfo

    var newLayoutInfo = [String: Dictionary<IndexPath, UICollectionViewLayoutAttributes>]()
    var cellLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
    var headerSupplementaryInfo = [IndexPath: UICollectionViewLayoutAttributes]()
    //        var decorationLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()

    enumerateCollectionItems { (ip, attr, item) in
      if ip.item == 0, let attributes = sectionHeaderAttributes(at: ip) {
        headerSupplementaryInfo[ip] = attributes
      }
      if let attributes = globalCache[collectionViewCellKind]?[ip] {
        cellLayoutInfo[ip] = attributes
      } else {
        var attributes = attr
        configure(attributes: &attributes, with: item, at: ip)
        cellLayoutInfo[ip] = attributes
      }
    }

    newLayoutInfo[collectionViewCellKind] = cellLayoutInfo
    newLayoutInfo[UICollectionView.elementKindSectionHeader] = headerSupplementaryInfo
    //        newLayoutInfo[collectionViewSupplimentaryKind] = supplimentaryLayoutInfo;
    //        newLayoutInfo[collectionViewDecorationKind] = decorationLayoutInfo;

    if isDebugging {
      Logger.shared.debug("layoutInfo: \(newLayoutInfo)")
    }

    layoutInfo = newLayoutInfo
  }
}
