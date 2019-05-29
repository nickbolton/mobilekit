//
//  GloballyCachingCollectionViewLayout.swift
//  MobileKit
//
//  Created by Nick Bolton on 5/9/19.
//  Copyright © 2019 Playboy Enterprises International, Inc. All rights reserved.
//

import UIKit

open class GloballyCachingCollectionViewLayout: BaseCollectionViewLayout {

    private var globalCache = [String: [IndexPath: UICollectionViewLayoutAttributes]]()
    
    open override func prepare() {
        oldLayoutInfo = layoutInfo
        
        var newLayoutInfo = [String: Dictionary<IndexPath, UICollectionViewLayoutAttributes>]()
        var cellLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
        //        var supplimentaryLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
        //        var decorationLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
        
        enumerateCollectionItems { (ip, attr, item) in
            if let attributes = globalCache[collectionViewCellKind]?[ip] {
                cellLayoutInfo[ip] = attributes
            } else {
                var attributes = attr
                configure(attributes: &attributes, with: item, at: ip)
                cellLayoutInfo[ip] = attributes
            }
        }
        
        newLayoutInfo[collectionViewCellKind] = cellLayoutInfo;
        //        newLayoutInfo[collectionViewSupplimentaryKind] = supplimentaryLayoutInfo;
        //        newLayoutInfo[collectionViewDecorationKind] = decorationLayoutInfo;
        
        if isDebugging {
            Logger.shared.debug("layoutInfo: \(newLayoutInfo)")
        }
        
        layoutInfo = newLayoutInfo
    }
}
