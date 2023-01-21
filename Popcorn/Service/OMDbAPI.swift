//
//  OMDbAPI.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 19.01.2023.
//

import Foundation
import Alamofire

protocol OMDbAPIProtocol {
    func fetchMovies(with name: String) async throws -> MovieResponse
    func fetchImage(path: String) async throws -> Data
}

open class OMDbAPI: OMDbAPIProtocol {
    
    func fetchMovies(with name: String) async throws -> MovieResponse {
        let movieResponse = try await AF.request(AppConstants.API.BaseURL + "s=" + name).serializingDecodable(MovieResponse.self).value
        return movieResponse
    }
    
    func fetchImage(path: String) async throws -> Data {
        let imageData = try await AF.download(path).serializingData().value
        return imageData
    }
}
