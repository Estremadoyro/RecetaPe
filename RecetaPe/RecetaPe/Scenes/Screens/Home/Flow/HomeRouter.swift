//
//  HomeRouter.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

protocol HomeRoutable: AnyObject {
    func start(presenter: HomePresentable) -> any Screen
    func handle(action: HomeAction)
}

final class HomeRouter: HomeRoutable {
    // MARK: State
    private weak var navigation: RPeNavigation?

    // MARK: Initializers
    init(navigation: RPeNavigation) {
        self.navigation = navigation
    }

    // MARK: Methods
    func start(presenter: HomePresentable) -> any Screen {
        return HomeScreen(presenter: presenter)
    }

    func handle(action: HomeAction) {
        switch action {
            case .transition(let screenType):
                handle(transition: screenType)
        }
    }
}

private extension HomeRouter {
    func handle(transition: ScreenType) {
        if case .recipeDetail(let recipe) = transition {
            openRecipeDetailScreen(with: recipe)
        }
    }

    func openRecipeDetailScreen(with recipe: Recipe) {
        guard let detailModule = RecetaPeModule.shared.getModule(by: .recipeDetail(recipe: recipe))
            as? RecipeDetailModule else { return }
        guard let controller = detailModule.start().topViewController else { return }
        detailModule.build(with: recipe)
        
        navigation?.pushViewController(controller, animated: true)
    }
}
