//
//  HomeRouter.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit

protocol HomeRoutable: AnyObject {
    func start(presenter: HomePresentable) -> any Screen
}

final class HomeRouter: HomeRoutable {
    // MARK: State
    private weak var navigation: CustomNavigation?

    // MARK: Initializers
    init(navigation: UINavigationController) {
        self.navigation = navigation as? CustomNavigation
    }

    // MARK: Methods
    func start(presenter: HomePresentable) -> any Screen {
        return HomeScreen(presenter: presenter)
    }
}
