//
//  HomeNavBar.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit

final class HomeNavBar: NavBarConfigurable {
    // MARK: State
    weak var screen: (any Screen)?
    
    // MARK: Initializers
    init(_ screen: any Screen) {
        self.screen = screen
    }
    
    // MARK: Methods
    func configureTitle(with title: String? = nil) {
        guard let title = title else { return }
        
        screen?.navigationItem.title = title
    }

    func configureLeftItems() {
        let darkModeItem = UIBarButtonItem(image: RPEIcon.lightMode,
                                           style: .plain,
                                           target: self,
                                           action: #selector(didTapDarkMode))
        let items: [UIBarButtonItem] = [darkModeItem]
        
        screen?.navigationItem.leftBarButtonItems = items
    }
    
    func configureRightItems() {
        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
        let icon = RPEIcon.selectItems.withConfiguration(configuration)
        
        let image = icon
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(RPEColor.black)
        
        let selectItemsItem = UIBarButtonItem(image: image,
                                              style: .plain,
                                              target: self,
                                              action: #selector(didTapSelectItems))
        let items: [UIBarButtonItem] = [selectItemsItem]
        
        screen?.navigationItem.rightBarButtonItems = items
    }
}

private extension HomeNavBar {
    @objc
    func didTapDarkMode() {}
    
    @objc
    func didTapSelectItems() {}
}
