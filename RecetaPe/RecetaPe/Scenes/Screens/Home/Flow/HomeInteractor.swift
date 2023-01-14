//
//  HomeInteractor.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import RxSwift
import RxCocoa

protocol HomeInteractive: AnyObject {
    var recipes: Driver<[Recipe]> { get }
    func saveRecipe(_ recipe: Recipe)
    func getRecipes()
    func resetFilteredRecipes()
}

final class HomeInteractor {
    // MARK: State
    private let recipeRepository: RecipeRepository
    private let recipesStore = BehaviorRelay<[Recipe]>(value: [])
    private let recipesStoreFiltered = BehaviorRelay<[Recipe]>(value: [])
    private lazy var disposeBag = DisposeBag()

    // MARK: Initializers
    init(recipeRepository: RecipeRepository) {
        self.recipeRepository = recipeRepository
    }
}

extension HomeInteractor: HomeInteractive {
    var recipes: Driver<[Recipe]> {
        recipesStoreFiltered.skip(1).asDriver(onErrorJustReturn: [])
    }

    /// Save repository, and use observable to update recipeRepository
    func saveRecipe(_ recipe: Recipe) {}

    /// Get remote recipes and update **recipesStore**.
    func getRecipes() {
        recipeRepository.getRecipes()
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] (recipes) in
                guard let self = self else { return }
                self.recipesStore.accept(recipes)
                self.recipesStoreFiltered.accept(recipes)
            })
            .disposed(by: disposeBag)
    }
    
    func resetFilteredRecipes() {
        recipesStoreFiltered.accept(recipesStore.value)
    }
}
