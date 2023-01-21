//
//  MovieDetailViewModel.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 19.01.2023.
//

import Foundation

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    weak var delegate: MovieDetailViewModelDelegate?
    private let movie: Movie
    private let posterData: Data
    
    init(movie: Movie, posterData: Data) {
        self.movie = movie
        self.posterData = posterData
    }
    
    func load() {
        let presentation = MovieDetailPresentation(movie: movie, posterData: posterData)
        delegate?.showDetail(presentation)
    }
}
