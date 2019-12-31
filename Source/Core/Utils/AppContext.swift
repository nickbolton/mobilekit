//
//  AppContext.swift
//  MobileKit
//
//  Created by Nick Bolton on 12/28/19.
//

import UIKit

public protocol AppContextAware {
  var appContext: AppContext! { get set }
}

public class AppContext {
  public static let shared = AppContext()
  
  private var contextItems: [String: Any] = Dictionary()
  
  public func registerItem(_ item: Any, withKey key: String) {
    contextItems[key] = item
    if var aware = item as? AppContextAware {
      aware.appContext = self
    }
  }
  
  public func lookupItem(_ key: String) -> Any? {
    return contextItems[key]
  }
  
  public subscript(key: String) -> Any? {
    get {
      return contextItems[key]
    }
    set {
      contextItems[key] = newValue
    }
  }
}
