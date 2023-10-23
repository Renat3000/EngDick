//
//  BaseTabBarController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(viewController: DictionaryController(), title: "Dictionary", imageName: "character.book.closed.fill"),
            createNavController(viewController: FavoritesController(), title: "Favorites", imageName: "star.fill")
        ]
    }
    // should fix this problem with UIViewController when I actually use 1 UICollectionViewController and plan to use tableViewController
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .systemGray4
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        return navController
    }
}
