//
//  OperationsManager.swift
//  Here
//
//  Created by Nick Bolton on 3/3/21.
//  Copyright © 2021 H3r3, Inc. All rights reserved.
//

import UIKit

public class OperationsManager: NSObject {
  
  static public let shared = OperationsManager()
  private override init() {}
  
  private let concurrentQueue = OperationQueue()
  private let serialQueue = SerialOperationQueue()
  
  // MARK: Public
  
  public func concurrentlyQueueOperation(_ op: Operation) {
    concurrentQueue.addOperation(op)
  }
  
  public func seriallyQueueOperation(_ op: Operation) {
    serialQueue.addOperation(op)
  }
  
  public func cancelAllOperations() {
    cancelQueuedOperations()
    cancelConcurrentOperations()
  }
  
  public func cancelQueuedOperations() {
    serialQueue.cancelAllOperations()
  }
  
  public func cancelConcurrentOperations() {
    concurrentQueue.cancelAllOperations()
  }
}
