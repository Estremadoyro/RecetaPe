//
//  RecipeDetailInteractor.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import RxSwift
import RxCocoa

protocol RecipeDetailInteractive {
    var recipe: Driver<Recipe> { get }
    func updateRecipe(with recipe: Recipe)
}

final class RecipeDetailInteractor {
    // MARK: State
    private let recipeRepository: RecipeRepository
    private let recipeStore = BehaviorRelay<Recipe?>(value: nil)
    private lazy var disposeBag = DisposeBag()

    // MARK: Initializers
    init(recipeRepository: RecipeRepository) {
        self.recipeRepository = recipeRepository
    }
}

extension RecipeDetailInteractor: RecipeDetailInteractive {
    var recipe: Driver<Recipe> {
        recipeStore
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: Recipe())
    }

    func updateRecipe(with recipe: Recipe) {
        recipeStore.accept(recipe)
    }
}
