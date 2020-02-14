//
//  Movie.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 2/13/20.
//  Copyright © 2020 Jesus Bernal Lopez. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let backdropPath: String?
    
    func getPosterPathUrlString() -> String {
        return posterPath != nil ? "https://image.tmdb.org/t/p/w500\(posterPath!)" : ""
    }
    
    func getBackdropPathUrlString() -> String {
        return backdropPath != nil ? "https://image.tmdb.org/t/p/w500\(backdropPath!)" : ""
    }
}
