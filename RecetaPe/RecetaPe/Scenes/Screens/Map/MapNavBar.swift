//
//  MapNavBar.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import UIKit

final class MapNavBar: NavBarConfigurable {
    // MARK: State
    weak var screen: UIViewController?

    // MARK: Initializers
    init(_ screen: UIViewController) {
        self.screen = screen
    }

    // MARK: Methods
    func configureTitle(with location: Location? = nil) {
        guard let location = location else { return }
        screen?.navigationController?.navigationBar.prefersLargeTitles = true
        screen?.navigationItem.title = "\(location.subtitle ?? ""), \(location.title ?? "")"
    }
}
