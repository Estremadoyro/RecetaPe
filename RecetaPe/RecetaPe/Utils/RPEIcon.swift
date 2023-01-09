//
//  RPEIcon.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit.UIImage

enum RPEIcon {
    static var darkMode: UIImage { UIImage(systemName: "circle.badge.2.fill") ?? UIImage() }
    static var lightMode: UIImage { UIImage(systemName: "circle.badge.2") ?? UIImage() }
    static var selectItems: UIImage { UIImage(systemName: "slider.horizontal.3") ?? UIImage() }
}
