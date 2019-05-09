//
//  View+Helpers.swift
//  MobileKit
//
//  Created by Nick Bolton on 6/28/16.
//  Copyright © 2016 Pixelbleed, LLC. All rights reserved.
//

import UIKit

public extension UIView {
    
    var statusBarHeight: CGFloat { return UIApplication.shared.statusBarFrame.height }

    var safeRegionInsets: UIEdgeInsets {
        if #available(iOS 11, *) {
            return safeAreaInsets
        }
        return .zero
    }    
}
