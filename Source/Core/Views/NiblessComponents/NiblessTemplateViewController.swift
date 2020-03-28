//
//  NiblessTemplateViewController.swift
//  MobileKit
//
//  Created by Nick Bolton on 3/28/20.
//

import UIKit

open class NiblessTemplateViewController<T:UIView>: NiblessViewController {

  public var rootView: T { return view as! T }

  open override func loadView() {
      view = T()
  }
}
