//
//  HomePresenter.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import Foundation
import RxCocoa

enum HomeAction {
    case transition(ScreenType)
}

protocol HomePresentable: AnyObject {
    var recipes: Driver<[Recipe]> { get }
    func start() -> any Screen
    func handle(action: HomeAction)
    func getAllRecipes()
    func deleteRecipe(id: String)
    func addRecipe(_ recipe: Recipe)
    func saveRecipe(_ recipe: Recipe)
    func filterRecipes(_ recipes: [Recipe], input: String) -> [Recipe]
    func resetFilteredRecipes()
}

final class HomePresenter {
    // MARK: State
    private let interactor: HomeInteractive
    private let router: HomeRoutable
    weak var view: (any Screen)?

    // MARK: Initializers
    init(router: HomeRoutable, interactor: HomeInteractive) {
        self.router = router
        self.interactor = interactor
    }
}

extension HomePresenter: HomePresentable {
    var recipes: Driver<[Recipe]> {
        interactor.recipes
    }

    func start() -> any Screen {
        return router.start(presenter: self)
    }

    func handle(action: HomeAction) {
        router.handle(action: action)
    }

    func getAllRecipes() {
        interactor.getRecipes()
    }

    func saveRecipe(_ recipe: Recipe) {}

    func addRecipe(_ recipe: Recipe) {}

    func deleteRecipe(id: String) {}

    func filterRecipes(_ recipes: [Recipe], input: String) -> [Recipe] {
        guard !input.isEmpty else { return recipes }
        let filtered: [Recipe] = recipes.filter { $0.name.lowercased().contains(input.lowercased()) }
        Logger<Self>.log("filtered: \(filtered.map { $0.name })")
        guard !filtered.isEmpty else { return recipes }
        return filtered
    }
    
    func resetFilteredRecipes() {
        interactor.resetFilteredRecipes()
    }
}
