//
//  SceneDelegate.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        /// # Setting up the app to lauch from VC without storyboards.
        /*
         Each screen-module of the can be "booted" from, meaning you can launch the app directly into a specific screen.
         This is useful for developing as the boot type will be shorter as less modules will have to be loaded.
         The module-screen(navigation) relation is 1-on-1, there is 1 screen(navigation) per module.
         
         The bootable screens are the following:
            - Home
            - RecipeDetail
            - NewRecipe
            - SavedRecipes
            - Map
         i.e:
         Layout tab controller with 3 main screens -> .rootTabBar(screens: [.home, .map, .savedRecipes])
         */
        let bootManager = BootManager()
        let rootController: UIViewController = bootManager.getRootController(by: .rootTabBar(screens: [.home, .map, .savedRecipes]))
        
        window = UIWindow(frame: scene.screen.bounds)
        window?.windowScene = scene
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

