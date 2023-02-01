//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Filip Varda on 25.01.2023..
//

import Foundation

struct RMCharacter: Codable {
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMCharacterOrigin
    let location: RMCharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

/// Create RMCharacter from Core Data entity - RMCharacterEntity
extension RMCharacter {
    init(entity: RMCharacterEntity) {
        self.id = Int(entity.id)
        self.name = entity.name ?? ""
        self.status = RMCharacterStatus(rawValue: entity.status!) ?? .unknown
        self.species = entity.name ?? ""
        self.type = entity.name ?? ""
        self.gender = RMCharacterGender(rawValue: entity.gender!) ?? .unknown
        self.origin = RMCharacterOrigin(name: entity.origin ?? "", url: "")
        self.location = RMCharacterLocation(name: "", url: "")
        self.image = entity.image ?? ""
        self.episode = [entity.episode ?? ""]
        self.url = entity.url ?? ""
        self.created = entity.created ?? ""
    }
}


