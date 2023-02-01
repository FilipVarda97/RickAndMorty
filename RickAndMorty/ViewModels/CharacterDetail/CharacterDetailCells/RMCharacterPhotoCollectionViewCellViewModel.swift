//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Filip Varda on 28.01.2023..
//

import Foundation

/// ViewModel that manages RMCharacterPhotoCollectionViewCell logic
final class RMCharacterPhotoCollectionViewCellViewModel {
    private let imageUrl: URL?
    
    // MARK: - Init
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }

    // MARK: - Implementation
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.dowloadImage(url: imageUrl, completion: completion)
    }
}
