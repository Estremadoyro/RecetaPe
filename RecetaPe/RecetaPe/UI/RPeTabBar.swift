//
//  RPeTabBar.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit

final class RPeTabBar: UITabBarController {
    // MARK: State

    // MARK: Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        configureTabBar()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
    }
}

private extension RPeTabBar {
    func configureTabBar() {
        tabBar.barTintColor = RPeColor.white
        tabBar.unselectedItemTintColor = RPeColor.lightGray
        tabBar.tintColor = RPeColor.pink
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = CGFloat(180)
        
        /// Remove TabBar's line (iOS 14 and below)
        let appearance = tabBar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        tabBar.standardAppearance = appearance

        tabBar.layoutIfNeeded()
    }
}
