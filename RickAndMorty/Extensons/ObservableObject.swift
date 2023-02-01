//
//  ObservableObject.swift
//  RickAndMorty
//
//  Created by Filip Varda on 25.01.2023..
//

import Foundation

/// Observableobject that triggers the listener on value change.
/// See RMCharacterEpisodeCollectionViewCellViewModel
/// and RMCharacterEpisodeCollectionViewCell for data binding.
class ObservableObject<T> {
    var value: T {
        didSet {
            listener?(value)
        }
    }

    private var listener: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }

    func bind(_ listener: @escaping(T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
