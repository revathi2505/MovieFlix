//
//  NowPlaying.swift
//  MovieFlix
//
//  Created by Revathi on 01/04/22.
//

import Foundation

struct NowPlayingMovies: Codable {
    let result: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case result = "results"
    }
}

struct Movie: Codable {
    let title: String
    let overview: String
    let voteCount: Int
    let posterPath: String
    let backdropPath: String
    let releaseDate: String
    let rating: Float
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case id
    }
}
