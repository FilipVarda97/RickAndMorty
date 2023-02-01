//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Filip Varda on 25.01.2023..
//

import UIKit
import Foundation

/// ViewModel that manages RMCharacterCollectionViewCell logic
final class RMCharacterCollectionViewCellViewModel {
    public let id: Int
    public let characterName: String
    public let characterStatus: RMCharacterStatus
    private let characterImageUrl: URL?
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    init(id: Int, characterName: String, characterStatus: RMCharacterStatus, characterImageUrl: URL?) {
        self.id = id
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    //MARK: - Implementation
    public func fetchImage(completion: @escaping(Result<Data, Error>) -> Void) {
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.dowloadImage(url: url, completion: completion)
    }
}
