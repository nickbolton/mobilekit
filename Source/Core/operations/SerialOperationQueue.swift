//
//  SerialOperationQueue.swift
//  Here
//
//  Created by Nick Bolton on 3/3/21.
//  Copyright © 2021 H3r3, Inc. All rights reserved.
//

import UIKit

public class SerialOperationQueue: OperationQueue {

  override init() {
    super.init()
    maxConcurrentOperationCount = 1
  }
  
  override public func addOperation(_ op: Operation) {
    if let lastOperation = operations.last {
      if !lastOperation.isFinished {
        op.addDependency(lastOperation)
      }
    }
    super.addOperation(op)
  }
}
