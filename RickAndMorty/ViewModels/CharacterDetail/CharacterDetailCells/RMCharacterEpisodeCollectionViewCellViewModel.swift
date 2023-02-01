//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Filip Varda on 28.01.2023..
//

import Foundation

/// ViewModel that manages RMCharacterEpisodeCollectionViewCell logic
final class RMCharacterEpisodeCollectionViewCellViewModel {
    private let episodeDataUrl: URL?
    private var isFetching = false
    public var episodeObservable: ObservableObject<RMEpisode?> = ObservableObject(nil)
    
    // MARK: - Init
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
    
    // MARK: - Implementation
    public func fetchEpisode() {
        guard !isFetching,
              let url = episodeDataUrl,
              let request = RMRequest(url: url),
              episodeObservable.value == nil
        else { return }

        isFetching = true
        RMService.shared.execute(request, expected: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episodeObservable.value = model
                }
            case .failure:
                break
            }
        }
    }
}
