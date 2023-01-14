//
//  MapComponentViewModel.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import RxSwift
import RxCocoa

protocol MapViewModable: AnyObject {
    var recipe: Driver<Recipe> { get }
    func updateRecipe(with recipe: Recipe)
}

final class MapComponentViewModel: MapViewModable {
    // MARK: State
    private let recipeStore = BehaviorRelay<Recipe?>(value: nil)

    // MARK: Initializers
    init() {}

    // MARK: Methods
    var recipe: Driver<Recipe> {
        recipeStore
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: Recipe())
    }

    func updateRecipe(with recipe: Recipe) {
        recipeStore.accept(recipe)
    }
}
