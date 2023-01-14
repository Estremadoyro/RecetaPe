//
//  TabBarManager.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit

/// Manges the CustomTabBar which will be the root controller.
///
/// The app will handle 3 TabBar items.
/// - Home
/// - Map
/// - Saved Recipes
final class TabBarManager {
    // MARK: State
    private lazy var tabBarController = RPeTabBar()
    private let screens: [ScreenType]

    // MARK: Initializers
    init(screenTypes: [ScreenType]) {
        self.screens = screenTypes
    }

    // MARK: Methods
    func setup() {
        setViewControllers()
    }

    func getRootTabBar() -> RPeTabBar {
        return tabBarController
    }
}

private extension TabBarManager {
    func setViewControllers() {
        let factory = ChildModuleFactory()
        let filteredScreens = screens.filter(screenFilter)
        var controllers = filteredScreens.map { factory.getChildModule(by: $0).start() }
        configureTabBarItems(with: &controllers)

        tabBarController.setViewControllers(controllers, animated: false)
    }

    /// Filters the screens  by  removing the ones which **cannot** have their own TabBar Item.
    ///
    /// The current only screens with TabBar Items are:
    ///  - Home
    ///  - Map
    ///  - SavedRecipes
    func screenFilter(screen: ScreenType) -> Bool {
        let allowedScreens: [ScreenType] = [.home, .map, .savedRecipes]
        return allowedScreens.contains(screen)
    }

    func configureTabBarItems(with navigations: inout [RPeNavigation]) {
        let rootControllers = navigations.map { $0.topViewController }
        rootControllers.enumerated().forEach { index, vc in
            if let home = vc as? HomeScreen {
                home.tabBarItem = UITabBarItem(title: "Home", image: RPeIcon.home, tag: index)
            }
        }
    }
}
