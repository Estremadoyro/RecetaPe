//
//  HomePresenter.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import Foundation

protocol HomePresentable: AnyObject {
    func start() -> any Screen
}

final class HomePresenter: HomePresentable {
    // MARK: State
    private let interactor: HomeInteractive
    private let router: HomeRoutable
    weak var view: (any Screen)?
    
    // MARK: Initializers
    init(router: HomeRoutable, interactor: HomeInteractive) {
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: Methods
    func start() -> any Screen {
        return router.start(presenter: self)
    }
}
