//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Filip Varda on 25.01.2023..
//

import Foundation

struct RMEpisode: Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String

    private enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case id, name, episode, characters, url, created
    }
}
