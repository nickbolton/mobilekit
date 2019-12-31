//
//  CollectionSection.swift
//  MobileKit
//
//  Created by Nick Bolton on 12/23/19.
//

import UIKit

open class CollectionSection: NSObject {

  public var useCenter = false
  public var entity: Any?
  public var items = [CollectionItem]()
    
  @discardableResult
  public func set(entity: Any) -> Self {
      self.entity = entity
      return self
  }
}
