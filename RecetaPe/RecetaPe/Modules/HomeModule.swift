//
//  HomeModule.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit

final class HomeModule: ChildModule {
    typealias Module = HomeModule
    
    // MARK: State
    private let presenter: HomePresenter
    private let navigation = CustomNavigation()
    
    // MARK: Initializers
    init() {
        let interactor = HomeInteractor()
        let router = HomeRouter(navigation: navigation)
        let presenter = HomePresenter(router: router, interactor: interactor)
        
        self.presenter = presenter
    }
   
    // MARK: Methods
    func start() -> CustomNavigation {
        let screen = presenter.start()
        navigation.setViewControllers([screen], animated: false)
        presenter.view = screen
        
        return navigation
    }
}
