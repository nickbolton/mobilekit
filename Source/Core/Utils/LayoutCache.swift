//
//  LayoutCache.swift
//  MobileKit
//
//  Created by Nick Bolton on 12/29/19.
//

import UIKit
import Cache

public class LayoutCache {

  private let storage: Storage?
  
  private struct CGFloatEntry: Codable {
    let value: CGFloat
  }
  
  private struct CGSizeEntry: Codable {
    let value: CGSize
  }
  
  private struct CGRectEntry: Codable {
    let value: CGRect
  }
  
  public init() {
    let directory = Bundle.main.bundleIdentifier ?? "MobileKit"
    let diskConfig = DiskConfig(
      // The name of disk storage, this will be used as folder name within directory
      name: "layoutCache",
      maxSize: 100000,
      directory: try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask,
                                              appropriateFor: nil, create: true).appendingPathComponent(directory)
    )
    let memoryConfig = MemoryConfig(
      countLimit: 1000,
      totalCostLimit: 0
    )
    do {
      storage = try Storage(diskConfig: diskConfig, memoryConfig: memoryConfig)
    } catch {
      print(error)
      storage = nil
    }
  }
  
  public func removeAll() {
    try? storage?.removeAll()
  }
  
  public func remove(forKey key: String) {
    try? storage?.removeObject(forKey: key)
  }
  
  public func height(forKey key: String) -> CGFloat? {
    guard let entry = try? storage?.object(ofType: CGFloatEntry.self, forKey: key) else { return nil }
    return entry?.value
  }
    
  public func store(height: CGFloat, forKey key: String) {
    try? storage?.setObject(CGFloatEntry(value: height), forKey: key)
  }

  public func size(forKey key: String) -> CGSize? {
    guard let entry = try? storage?.object(ofType: CGSizeEntry.self, forKey: key) else { return nil }
    return entry?.value
  }
    
  public func store(size: CGSize, forKey key: String) {
    try? storage?.setObject(CGSizeEntry(value: size), forKey: key)
  }

  public func rect(forKey key: String) -> CGRect? {
    guard let entry = try? storage?.object(ofType: CGRectEntry.self, forKey: key) else { return nil }
    return entry?.value
  }
    
  public func store(rect: CGRect, forKey key: String) {
    try? storage?.setObject(CGRectEntry(value: rect), forKey: key)
  }
}
