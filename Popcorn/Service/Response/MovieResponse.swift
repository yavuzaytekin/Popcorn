//
//  MovieResponse.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 19.01.2023.
//

import Foundation

// MARK: - MovieResponse
struct MovieResponse: Codable {
    let movies: [Movie]
    let totalResults, response: String

    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Movie
struct Movie: Codable {
    let title, year, imdbID: String
    let type: TypeEnum
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
    case series = "series"
}
