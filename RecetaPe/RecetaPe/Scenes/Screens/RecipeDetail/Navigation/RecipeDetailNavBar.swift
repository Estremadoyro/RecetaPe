//
//  RecipeDetailNavBar.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import UIKit

final class RecipeDetailNavBar: NavBarConfigurable {
    // MARK: State
    weak var screen: (any Screen)?
    
    // MARK: Initializers
    init(_ screen: any Screen) {
        self.screen = screen
    }
    
    // MARK: Methods
    func configureTitle(with title: String? = nil) {
        guard let title = title else { return }
        screen?.navigationController?.navigationBar.prefersLargeTitles = true
        screen?.navigationItem.title = title
    }
    
    func configureRightItems() {
        let configuration = UIImage.SymbolConfiguration(weight: .regular)
        let icon = RPeIcon.share.withConfiguration(configuration)
        
        let shareItem = UIBarButtonItem(image: icon,
                                              style: .plain,
                                              target: self,
                                              action: #selector(didTapShare))
        let items: [UIBarButtonItem] = [shareItem]
        
        screen?.navigationItem.rightBarButtonItems = items
    }
}

private extension RecipeDetailNavBar {
    @objc
    func didTapShare() {}
}
