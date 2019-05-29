/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

public protocol Themeable: class {
  func applyTheme()
}

protocol InternalThemeable: Themeable {
}

open class NiblessView: UIView, InternalThemeable {
  
  // MARK: - Properties
  
  private (set) public var isHierarchyReady = false

  public override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable,
    message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
  )
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
  }
  
  // MARK: - Methods
  open override func didMoveToWindow() {
    super.didMoveToWindow()
    guard !isHierarchyReady else { return }
    constructHierarchy()
    activateConstraints()
    applyTheme()
    isHierarchyReady = true
    didFinishInitialization()
  }
  
  open func didFinishInitialization() {
  }

  open func constructHierarchy() {
  }
  
  open func activateConstraints() {
  }
  
  open func applyTheme() {
    walkViewHierarchy { v -> Bool in
      if let themeable = v as? Themeable {
        themeable.applyTheme()
      }
      return (v as? InternalThemeable) != nil
    }
  }
  
  open override func setNeedsDisplay() {
    super.setNeedsDisplay()
    applyTheme()
  }
}
