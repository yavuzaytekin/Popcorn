//
//  MovieDetailBuilder.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 21.01.2023.
//

import Foundation

final class MovieDetailBuilder {
    
    static func make(with viewModel: MovieDetailViewModelProtocol) -> MovieDetailViewController {
        let viewController = MovieDetailViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
