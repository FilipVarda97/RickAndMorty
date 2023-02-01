//
//  RMCharacterListView.swift
//  RickAndMorty
//
//  Created by Filip Varda on 25.01.2023..
//

import UIKit
import SnapKit

protocol RMCharacterListViewDelegate: AnyObject {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter)
}

/// A view that represents RMCharacterListView
final class RMCharacterListView: UIView {
    private let viewModel = RMCharacterListViewViewModel()
    weak var delegate: RMCharacterListViewDelegate?
    
    enum RMCharacterListStorageType {
        case server
        case localStorage
    }
    private var type: RMCharacterListStorageType?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isHidden = true
        collection.alpha = 0
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(RMCharacterListCollectionViewCell.self,
                            forCellWithReuseIdentifier: RMCharacterListCollectionViewCell.identifier)
        collection.register(RMFooterLoadingCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collection
    }()

    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
        setUpCollectionView()
    }
    
    convenience init(frame:CGRect, type: RMCharacterListStorageType) {
        self.init(frame: frame)
        self.type = type
        viewModel.delegate = self
        switch type {
        case .server:
            fetchInitialCharacters()
        case .localStorage:
            checkLocalStorage()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    //MARK: - Implementation
    private func setUpViews() {
        backgroundColor = .systemGray5
        addSubviews(collectionView, spinner)
    }
    
    private func setUpConstraints() {
        spinner.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalTo(self)
        }
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self)
        }
    }

    private func setUpCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }

    private func fetchInitialCharacters() {
        spinner.startAnimating()
        viewModel.fetchInitialCharacters()
    }

    private func checkLocalStorage() {
        spinner.startAnimating()
        viewModel.loadFromLocalStorage()
    }
    
    public func updateFromLocalStorage() {
        spinner.startAnimating()
        viewModel.updateCharactersFromLocalStorage()
    }
}

//MARK: - RMCharacterListViewViewModelDelegate
extension RMCharacterListView: RMCharacterListViewViewModelDelegate {
    func didLoadCharacters() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.collectionView.alpha = 1
        }
    }

    func didSelectCharacter(_ character: RMCharacter) {
        delegate?.rmCharacterListView(self, didSelectCharacter: character)
    }

    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }

    func didLoadCharactersFromLocalStorage() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.collectionView.alpha = 1
        }
    }

    func refreshedCharactersFromLocalStorage() {
        spinner.stopAnimating()
        collectionView.reloadData()
    }
}

