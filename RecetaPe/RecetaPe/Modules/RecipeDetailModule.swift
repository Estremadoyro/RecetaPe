//
//  RecipeDetailModule.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import Foundation

final class RecipeDetailModule: ChildModule {
    typealias Module = RecipeDetailModule
    
    // MARK: State
    private let presenter: RecipeDetailPresenter
    private let navigation = RPeNavigation()
    
    // MARK: Initializers
    init(recipeRepository: RecipeRepository) {
        let interactor = RecipeDetailInteractor(recipeRepository: recipeRepository)
        let router = RecipeDetailRouter()
        let presenter = RecipeDetailPresenter(router: router, interactor: interactor)
        router.presenter = presenter
        
        self.presenter = presenter
    }
   
    // MARK: Methods
    func start() -> RPeNavigation {
        let screen = presenter.start()
        navigation.setViewControllers([screen], animated: false)
        presenter.view = screen
        
        return navigation
    }
    
    func build(with recipe: Recipe) {
        presenter.updateRecipe(with: recipe)
    }
}
