//
//  AppContainer.swift
//  Popcorn
//
//  Created by Yavuz Aytekin on 20.01.2023.
//

import Foundation

let app = AppContainer()

final class AppContainer {
    let service = OMDbAPI()
    let router = AppRouter()
}
