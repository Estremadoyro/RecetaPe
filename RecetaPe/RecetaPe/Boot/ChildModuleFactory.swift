//
//  ScreenFactory.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import Foundation

final class ChildModuleFactory {
    // MARK: State
    
    // MARK: Initializers
    init() {}
    
    // MARK: Methods
    /// Gets a base-module-controller (navigation) by  module.
    /// - Parameter module: The type of module to get the navigation from.
    /// - Returns: Custom navigation controller
    func getChildModule(by module: ScreenType) -> any ChildModule {
        return RecetaPeModule.shared.getModule(by: module)
    }
}
