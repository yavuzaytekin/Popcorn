//
//  MovieListBuilder.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 20.01.2023.
//

import Foundation

final class MovieListBuilder {
    
    static func make() -> MovieListViewController {
        let viewController = MovieListViewController()
        viewController.viewModel = MovieListModelView(service: app.service)
        return viewController
    }
}
