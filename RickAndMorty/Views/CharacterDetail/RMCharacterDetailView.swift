//
//  RMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Filip Varda on 26.01.2023..
//

import UIKit

protocol RMCharacterDetailViewDelegate: AnyObject {
    func rmCharacterDetailView(_ characterDetailView: RMCharacterDetailView, didSelectEpisode episode: RMEpisode)
    func rmCharacterDetailView(_ characterDetailView: RMCharacterDetailView, shouldEnableDelete: Bool)
}

/// A view that represents RMCharacterDetailView
final class RMCharacterDetailView: UIView {
    private var collectionView: UICollectionView?
    private var viewModel: RMCharacterDetailViewViewModel
    weak var delegate: RMCharacterDetailViewDelegate?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // MARK: - Init
    init(frame: CGRect, viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        self.viewModel.delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        let collectionView = createColletionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    private func addConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        spinner.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalTo(self)
        }
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self)
        }
    }

    private func createColletionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(RMCharacterPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterPhotoCollectionViewCell.identifier)
        collectionView.register(RMCharacterInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterInfoCollectionViewCell.identifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier)

        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel

        return collectionView
    }

    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        switch viewModel.sections[sectionIndex] {
        case .photo:
            return viewModel.createPhotoSection()
        case .information:
            return viewModel.createInfoSection()
        case .episodes:
            return viewModel.createEpisodeSection()
        }
    }
}

extension RMCharacterDetailView: RMCharacterDetailViewViewModelDelegate {
    func enableDeleteCharacterButton() {
        delegate?.rmCharacterDetailView(self, shouldEnableDelete: true)
    }
    
    func didSelectEpisode(_ episode: RMEpisode) {
        delegate?.rmCharacterDetailView(self, didSelectEpisode: episode)
    }
}
