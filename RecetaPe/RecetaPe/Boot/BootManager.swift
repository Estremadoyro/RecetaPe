//
//  BootManager.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit.UIViewController

enum RootController {
    case rootModuleController(ScreenType)
    case rootTabBar(screens: [ScreenType])
}

/// In charge of booting up the app by determing the appropiate boot root.
final class BootManager {
    // MARK: State
    
    // MARK: Initializers
    init() {}
    
    // MARK: Methods
    func getRootController(by root: RootController) -> UIViewController {
        switch root {
            case .rootModuleController(let module):
                let factory = ChildModuleFactory()
                return factory.getChildModule(by: module).start()
                
            case .rootTabBar(let screens):
                let controller = TabBarManager(screenTypes: screens)
                controller.setup()
                let tabBar = controller.getRootTabBar()
                return tabBar
        }
    }
}
