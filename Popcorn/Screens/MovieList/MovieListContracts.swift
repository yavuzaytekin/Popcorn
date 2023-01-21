//
//  MovieListViewModelProtocol.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 19.01.2023.
//

import Foundation

protocol MovieListViewModelProtocol {
    var delegate: MovieListViewModelDelegate? { get set }
    func load()
    func selectMovie(at index: Int, with posterData: Data)
    func searchMovies(with name: String) async
    func fetchImage(path: String) async -> Data?
}

enum MovieListViewModelOutput {
    case updateTitle(String)
    case setLoading(Bool)
    case showError(CustomError)
    case showMovieList([MoviePresentation])
}

enum MovieListViewRoute {
    case detail(MovieDetailViewModelProtocol)
}

protocol MovieListViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: MovieListViewModelOutput)
    func navigate(to route: MovieListViewRoute)
}
