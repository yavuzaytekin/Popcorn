//
//  AppRouter.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 21.01.2023.
//

import UIKit

protocol AppRouterProtocol {
    func start(with window: UIWindow?)
}

class AppRouter: AppRouterProtocol {
    func start(with window: UIWindow?) {
        guard let window = window else { return }
        
        let movieListViewController = MovieListBuilder.make()
        window.rootViewController = UINavigationController(rootViewController: movieListViewController)
        window.makeKeyAndVisible()
    }
}
