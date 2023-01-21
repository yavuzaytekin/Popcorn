//
//  MoviePresentation.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 19.01.2023.
//

import Foundation

final class MoviePresentation {
    
    let title: String
    let path: String
    
    init(movie: Movie) {
        self.title = movie.title
        self.path = movie.poster
    }
}
