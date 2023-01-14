//
//  RecipeDetailRouter.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

protocol RecipeDetailRoutable {
    var navigation: RPeNavigation? { get set }
    func setNavigation(with navigation: RPeNavigation?)
    func start(presenter: RecipeDetailPresentable) -> any Screen
    func openMap(with navigation: RPeNavigation?, recipe: Recipe)
}

final class RecipeDetailRouter {
    // MARK: State
    weak var navigation: RPeNavigation?
    weak var presenter: RecipeDetailPresentable?

    // MARK: Initializers
    init() {}

    // MARK: Methods
    func start(presenter: RecipeDetailPresentable) -> any Screen {
        return RecipeDetailScreen(presenter: presenter)
    }
    
    func setNavigation(with navigation: RPeNavigation?) {
        self.navigation = navigation
    }
}

extension RecipeDetailRouter: RecipeDetailRoutable {
    func openMap(with navigation: RPeNavigation?, recipe: Recipe) {
        let viewModel = MapComponentViewModel()
        viewModel.updateRecipe(with: recipe)
        let mapComponent = MapComponent(viewModel: viewModel)
        let controller = mapComponent.getController()
        navigation?.modalPresentationStyle = .pageSheet
        navigation?.present(controller, animated: true)
    }
}
