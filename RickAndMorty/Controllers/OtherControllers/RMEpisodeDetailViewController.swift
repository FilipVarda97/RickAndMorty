//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Filip Varda on 30.01.2023..
//

import UIKit

///A view controller responsible for presenting RMCharacterDetailView and navigation handling
final class RMEpisodeDetailViewController: UIViewController {
    private let episode: RMEpisode?
    
    // MARK: - Init
    init(episode: RMEpisode) {
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
    }
}
