//
//  RPeIcon.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit.UIImage

enum RPeIcon {
    static var darkMode: UIImage { UIImage(systemName: "circle.badge.2.fill") ?? UIImage() }
    static var lightMode: UIImage { UIImage(systemName: "circle.badge.2") ?? UIImage() }
    static var selectItems: UIImage { UIImage(systemName: "slider.horizontal.3") ?? UIImage() }
    static var star: UIImage { UIImage(systemName: "star.fill") ?? UIImage() }
    static var trash: UIImage { UIImage(systemName: "trash.fill") ?? UIImage() }
    static var share: UIImage { UIImage(systemName: "square.and.arrow.up") ?? UIImage() }

    /// # TabBar Icons
    static var home: UIImage { UIImage(systemName: "house") ?? UIImage() }
    static var map: UIImage { UIImage(systemName: "map") ?? UIImage() }
    static var save: UIImage { UIImage(systemName: "bookmark.fill") ?? UIImage() }
}
