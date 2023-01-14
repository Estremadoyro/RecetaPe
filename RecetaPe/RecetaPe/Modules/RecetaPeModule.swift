//
//  RecetaPeModule.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit

/// Each represent a significant part of the app. 1 Module has 1 screen.
enum ScreenType: Equatable {
    case home
    case recipeDetail(recipe: Recipe)
    case newRecipe
    case savedRecipes
    case map
}

/// Modules are in charge of building the **VIPER architecture**, and returning a **Screen** for use.
protocol ChildModule {
    /// Sets the navigation's controllers and returns a root navigation object.
    func start() -> RPeNavigation
}

/// In charge of manging and deliverying modules.
protocol MainModule {
    func getModule(by screen: ScreenType) -> any ChildModule
}

/// App's **Main Module** in charge of **deliverying** all the other modules.
final class RecetaPeModule: MainModule {
    // MARK: State
    /// # Instance
    static let shared = RecetaPeModule()
    
    /// # Local requestable
    private lazy var localManager = LocalManager()
    
    /// # Remote requestable
    private lazy var networkManager = NetworkManager.shared
    
    /// # Repositories
    private lazy var recipeRepository = RecipeRepository(networkManager: networkManager, localManager: localManager)
    
    /// # Child modules
    private lazy var homeModule = HomeModule(recipeRepository: recipeRepository)
    private lazy var recipeDetailModule = RecipeDetailModule(recipeRepository: recipeRepository)

    // MARK: Initializers
    private init() {}

    // MARK: Methods
    /// Get an app's module by it's *screen type*.
    /// - Parameter screen: The screen type.
    /// - Returns: Any child module.
    func getModule(by screen: ScreenType) -> any ChildModule {
        switch screen {
            case .home:
                return homeModule
            case .recipeDetail(let recipe):
                let module = recipeDetailModule
                module.build(with: recipe)
                return module
            default: return homeModule
        }
    }
}
