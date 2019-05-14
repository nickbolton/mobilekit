//
//  FileManager+Utils.swift
//  MobileKit
//
//  Created by Nick Bolton on 1/15/19.
//

import Foundation

extension FileManager {
  static public var documentsDirectory: URL {
    guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      fatalError("unable to get system docs directory - serious problems")
    }
    return documentsURL
  }
  
  static public var cachesDirectory: URL {
    guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      fatalError("unable to get system cache directory - serious problems")
    }
    return cacheURL
  }
}
