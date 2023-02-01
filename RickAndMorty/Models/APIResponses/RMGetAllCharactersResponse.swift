//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Filip Varda on 25.01.2023..
//

import Foundation

struct RMGetAllCharactersResponse: Codable {
    let info: Info
    let results: [RMCharacter]
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
