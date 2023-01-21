//
//  MovieDetailContracts.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 19.01.2023.
//

import Foundation

protocol MovieDetailViewModelDelegate: AnyObject {
    func showDetail(_ presentation: MovieDetailPresentation)
}

protocol MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate? { get set }
    func load()
}
