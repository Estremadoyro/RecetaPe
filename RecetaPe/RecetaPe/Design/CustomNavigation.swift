//
//  CustomNavigation.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit

protocol NavBarConfigurable {
    func configureLeftItems()
    func configureRightItems()
    func configureTitle(with title: String?)
}

extension NavBarConfigurable {
    func configureLeftItems() {}
    func configureRightItems() {}
    func configureTitle(with title: String?) {}
}

final class CustomNavigation: UINavigationController {
    // MARK: State
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }

    // MARK: Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        configure()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
}

extension CustomNavigation {
    func configure() {
        /// Settings
        navigationBar.backgroundColor = RPEColor.white

        /// Remove Navigations bar's line (iOS 14 and below)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
    }
}
