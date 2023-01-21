//
//  MovieListModelView.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 19.01.2023.
//

import Foundation

final class MovieListModelView: MovieListViewModelProtocol {
    
    weak var delegate: MovieListViewModelDelegate? 
    private var movies: [Movie] = []
    let service: OMDbAPIProtocol

    init(service: OMDbAPIProtocol) {
        self.service = service
    }
    
    func load() {
        notify(.updateTitle("Movies"))
    }
    
    func searchMovies(with name: String = "") async {
        notify(.setLoading(true))
        do {
            let result = try await service.fetchMovies(with: name)
            let presentations = result.movies.map({MoviePresentation(movie: $0)})
            
            self.movies = result.movies
            
            notify(.setLoading(false))
            notify(.showMovieList(presentations))
        } catch {
            notify(.setLoading(false))
            notify(.showError(.custom("Yavaş la kırdın")))
        }
    }
    
    func fetchImage(path: String) async -> Data? {
        do {
            let imageData = try await service.fetchImage(path: path)
            return imageData
        } catch {
            return nil
        }
    }
    
    func selectMovie(at index: Int, with posterData: Data) {
        let movie = movies[index]
        let viewModel = MovieDetailViewModel(movie: movie, posterData: posterData)
        delegate?.navigate(to: .detail(viewModel))
    }
    
    private func notify(_ output: MovieListViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
