//
//  RecetaPeModule.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import Foundation

/// Each represent a significant part of the app. 1 Module has 1 screen.
enum ScreenType {
    case home
    case recipeDetail
    case newRecipe
    case savedRecipes
    case map
}

/// Modules are in charge of building the **VIPER architecture**, and returning a **Screen** for use.
protocol ChildModule {
    /// Sets the navigation's controllers and returns a root navigation object.
    func start() -> CustomNavigation
}

/// In charge of manging and deliverying modules.
protocol MainModule {
    func getModule(by module: ScreenType) -> any ChildModule
}

/// App's **Main Module** in charge of **deliverying** all the other modules.
final class RecetaPeModule: MainModule {
    // MARK: State
    static let shared = RecetaPeModule()
    
    /// # Child modules
    private lazy var homeModule: any ChildModule = HomeModule()

    // MARK: Initializers
    private init() {}

    // MARK: Methods
    /// Get an app's module by it's *module type*.
    /// - Parameter module: The module type.
    /// - Returns: Any child module.
    func getModule(by module: ScreenType) -> any ChildModule {
        switch module {
            case .home:
                return homeModule
            default: return homeModule
        }
    }
}

