//
//  SceneDelegate.swift
//  Weather
//
//  Created by Sai Kiran on 06/08/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            
            /*
             1.Writing code in programatical approach - can be done using story boards
             2.Storing last location in documents in Json format, retrieve if the fire exists
             3.CacheStorage - class can help to save, read and delete the data if needed
             */
            let window = UIWindow(windowScene: windowScene)
            let navController:UINavigationController
            if let model = CacheStorage.retrieve(Constants.jsonFile, from: .documents, as: WeatherModel.self) {
                navController = UINavigationController(rootViewController: WeatherSearchVC(vm: WeatherViewModel(weatherModel: model)))
            } else {
                navController = UINavigationController(rootViewController: WeatherSearchVC(vm: WeatherViewModel()))
            }
            window.rootViewController = navController
            self.window = window
            window.makeKeyAndVisible()
        }
        guard let _ = (scene as? UIWindowScene) else { return }
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

