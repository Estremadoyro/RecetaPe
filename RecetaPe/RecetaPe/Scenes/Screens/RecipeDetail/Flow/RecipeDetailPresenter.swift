//
//  RecipeDetailPresenter.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import RxCocoa

protocol RecipeDetailPresentable: AnyObject {
    var recipe: Driver<Recipe> { get }
    func start() -> any Screen
    func updateRecipe(with recipe: Recipe)
    func openMap(with recipe: Recipe)
}

final class RecipeDetailPresenter {
    // MARK: State
    private let router: RecipeDetailRoutable
    private let interactor: RecipeDetailInteractive
    weak var view: (any Screen)?

    // MARK: Initializers
    init(router: RecipeDetailRoutable, interactor: RecipeDetailInteractive) {
        self.router = router
        self.interactor = interactor
    }

    // MARK: Methods
}

extension RecipeDetailPresenter: RecipeDetailPresentable {
    var recipe: Driver<Recipe> {
        interactor.recipe
    }
    
    func start() -> any Screen {
        return router.start(presenter: self)
    }
    
    func updateRecipe(with recipe: Recipe) {
        interactor.updateRecipe(with: recipe)
    }
    
    func openMap(with recipe: Recipe) {
        guard let navigation = view?.navigationController as? RPeNavigation else {
            Logger<Self>.log("Error accessing view's navigation controller.", .error)
            return
        }
        router.openMap(with: navigation, recipe: recipe)
    }
}
