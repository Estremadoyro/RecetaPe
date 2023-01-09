//
//  CustomTabBar.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit

final class CustomTabBar: UITabBarController {
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

private extension CustomTabBar {
    func configureTabBar() {
        tabBar.backgroundColor = RPEColor.white
        tabBar.barTintColor = RPEColor.white
        tabBar.unselectedItemTintColor = RPEColor.lightGray
        tabBar.tintColor = RPEColor.cobalt
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
