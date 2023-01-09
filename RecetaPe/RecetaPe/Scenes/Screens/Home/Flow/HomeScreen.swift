//
//  HomeScreen.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit

final class HomeScreen: UIViewController, Screen {
    // MARK: State
    private weak var presenter: HomePresentable?
    private lazy var navBarConfig = HomeNavBar(self)

    // MARK: Initializers
    init(presenter: HomePresentable) {
        super.init(nibName: nil, bundle: nil)

        self.presenter = presenter
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Life Cycle
extension HomeScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }
}

private extension HomeScreen {
    func configureScreen() {
        view.backgroundColor = RPEColor.white
        configureNavBar()
    }
}

private extension HomeScreen {
    func configureNavBar() {
        configureTitle()
        configureLeftItems()
        configureRightItems()
    }

    func configureTitle() {
        navBarConfig.configureTitle(with: "Recipes")
    }

    func configureLeftItems() {
        navBarConfig.configureLeftItems()
    }

    func configureRightItems() {
        navBarConfig.configureRightItems()
    }
}
