//
//  MovieDetailPresentation.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 21.01.2023.
//

import Foundation

struct MovieDetailPresentation {
    let title: String
    let artistName: String
    let posterData: Data
    
    init(movie: Movie, posterData: Data) {
        self.title = movie.title
        self.artistName = movie.year
        self.posterData = posterData
    }
}
