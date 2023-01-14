//
//  UIView+Layer.swift
//  RecetaPe
//
//  Created by Leonardo  on 9/01/23.
//

import UIKit.UIView

extension UIView {
    /// Adds corner radius to the current view.
    ///
    /// - Parameter radius: The corner's radius.
    func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
