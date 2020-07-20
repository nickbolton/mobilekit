//
//  NiblessRootView.swift
//  MobileKit
//
//  Created by Nick Bolton on 4/6/20.
//

import UIKit

open class NiblessRootView<VM:NSObject>: NiblessView {
  public static func buildViewModel() -> VM { VM() }
  public var viewModel = buildViewModel()
}
