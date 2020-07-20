//
//  NiblessViewModelViewController.swift
//  MobileKit
//
//  Created by Nick Bolton on 4/6/20.
//

import UIKit

open class NiblessViewModelViewController<VM:NSObject, V:NiblessRootView<VM>>: NiblessViewController {

  public var rootView: V { return view as! V }
  public var viewModel: VM!

  open override func loadView() {
    view = V()
    viewModel = rootView.viewModel
  }
}
