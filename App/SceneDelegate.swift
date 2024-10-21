//
//  SceneDelegate.swift
//  App
//
//  Created by Winky51 on 19.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: TaskViewController())
    }

   
    func sceneDidEnterBackground(_ scene: UIScene) {
        
        StorageManager.shared.saveContext()
       
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

