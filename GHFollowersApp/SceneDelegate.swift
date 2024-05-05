//
//  SceneDelegate.swift
//  GHFollowersApp
//
//  Created by abdullah on 4.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
      
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        window?.rootViewController = createTabbar()
        
        window?.makeKeyAndVisible()
        
        configureNavigationBar()
        
        
    }
    
    func createTabbar() -> UITabBarController {
        let tabbar = UITabBarController()
        UITabBar.appearance().tintColor = .systemGreen
        tabbar.viewControllers = [createSearchNC(),createsFavoritesNC()]
        return tabbar
    }
    
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }

    
    func createsFavoritesNC() -> UINavigationController {
        let favoriteListVC = FavoriteListVC()
        favoriteListVC.title = "Favorites"
        favoriteListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favoriteListVC)
    }

    
    func configureNavigationBar(){
        UINavigationBar.appearance().tintColor = .systemGreen
    }


}

