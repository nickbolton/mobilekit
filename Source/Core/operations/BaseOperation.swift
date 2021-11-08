//
//  BaseOperation.swift
//  Here
//
//  Created by Nick Bolton on 3/3/21.
//  Copyright © 2021 H3r3, Inc. All rights reserved.
//

import UIKit

open class BaseOperation: Operation {

  private var _isExecuting = false
  open override var isExecuting: Bool {
    get { return _isExecuting }
    set {
      willChangeValue(forKey: "isExecuting")
      _isExecuting = newValue
      didChangeValue(forKey: "isExecuting")
    }
  }

  private var _isFinished = false
  open override var isFinished: Bool {
    get { return _isFinished }
    set {
      willChangeValue(forKey: "isFinished")
      _isFinished = newValue
      didChangeValue(forKey: "isFinished")
    }
  }

  open override func main() {
    guard !isCancelled else { return }
    protectedMain()
  }
  
  open func protectedMain() {
    // abstract
  }
}
