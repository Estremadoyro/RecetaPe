//
//  TabBarManager.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import Foundation

/// Manges the CustomTabBar which will be the root controller.
///
/// The app will handle 3 TabBar items.
/// - Home
/// - Map
/// - Saved Recipes
final class TabBarManager {
    // MARK: State
    private lazy var tabBarController = CustomTabBar()
    private let screens: [ScreenType]

    // MARK: Initializers
    init(screenTypes: [ScreenType]) {
        self.screens = screenTypes
    }

    // MARK: Methods
    func setup() {
        setViewControllers()
    }
    
    func getRootTabBar() -> CustomTabBar {
        return tabBarController
    }
}

private extension TabBarManager {
    func setViewControllers() {
        let factory = ChildModuleFactory()
        let filteredScreens = screens.filter(screenFilter)
        let controllers = filteredScreens.map { factory.getChildModule(by: $0).start() }

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
}
