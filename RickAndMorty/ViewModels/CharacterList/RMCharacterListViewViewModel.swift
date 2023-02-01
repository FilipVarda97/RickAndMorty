//
//  RMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Filip Varda on 25.01.2023..
//

import UIKit
import CoreData

/// Protocol that handles callback from fetching data and provides it to RMCharacterListView
protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadCharactersFromLocalStorage()
    func refreshedCharactersFromLocalStorage()
    func didLoadCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
}

/// ViewModel that manages RMCharacterListView logic
final class RMCharacterListViewViewModel: NSObject {
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    private var isLoadingMoreCharacters = false
    private var isLoadingInitialCharacters = false
    private var info: Info?
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []

    private var loadedCharacters: [RMCharacter] = [] {
        didSet {
            cellViewModels.removeAll()
            for character in loadedCharacters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    id: character.id,
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image))
                cellViewModels.append(viewModel)
            }
        }
    }
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters where !cellViewModels.contains(where: { $0.id == character.id }){
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    id: character.id,
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image))
                cellViewModels.append(viewModel)
            }
        }
    }
    
    public var shouldShowMoreIndicator: Bool {
        return info?.next != nil
    }

    //MARK: - Implementation
    public func fetchInitialCharacters() {
        isLoadingInitialCharacters = true
        RMService.shared.execute(.listAllCharactersRequest, expected: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                let characterResults = response.results
                let info = response.info
                self?.characters = characterResults
                self?.info = info
                DispatchQueue.main.async {
                    self?.isLoadingInitialCharacters = false
                    self?.delegate?.didLoadCharacters()
                }
            case .failure(let error):
                self?.isLoadingInitialCharacters = false
                print(error)
            }
        }
    }

    public func fetchAdtitionalCharacters(url: URL) {
        guard let rmRequest = RMRequest(url: url) else { return }
        isLoadingMoreCharacters = true
        RMService.shared.execute(rmRequest, expected: RMGetAllCharactersResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let response):
                let moreCharacters = response.results
                let info = response.info
                strongSelf.info = info

                let originalCount = strongSelf.characters.count
                let newCount = moreCharacters.count
                let totalCount = originalCount + newCount
                let startingIndex = totalCount - newCount
                let newIndexPaths: [IndexPath] = Array(startingIndex ..< (startingIndex + newCount)).compactMap {
                    return IndexPath(item: $0, section: 0)
                }
                strongSelf.characters.append(contentsOf: moreCharacters)
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(with: newIndexPaths)
                    strongSelf.isLoadingMoreCharacters = false
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreCharacters = false
                }
            }
        }
    }

    public func loadFromLocalStorage() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        do {
            let request = RMCharacterEntity.fetchRequest()
            let characters = try managedObjectContext.fetch(request)
            let rmCharacters = characters.compactMap {
                return RMCharacter(entity: $0)
            }
            loadedCharacters = rmCharacters
            delegate?.didLoadCharactersFromLocalStorage()
            
        } catch let error as NSError {
            print("Error saving context: \(error), \(error.userInfo)")
        }
    }

    public func updateCharactersFromLocalStorage() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        do {
            let request = RMCharacterEntity.fetchRequest()
            let characters = try managedObjectContext.fetch(request)
            let rmCharacters = characters.compactMap {
                return RMCharacter(entity: $0)
            }
            loadedCharacters = rmCharacters
            delegate?.refreshedCharactersFromLocalStorage()
            
        } catch let error as NSError {
            print("Error saving context: \(error), \(error.userInfo)")
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension RMCharacterListViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cellViewModels.isEmpty {
            collectionView.backgroundView = RMEmptyCollectionView()
            return 0
        }
        collectionView.backgroundView = nil
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterListCollectionViewCell.identifier, for: indexPath) as? RMCharacterListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureWith(cellViewModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth-30)/2
        return CGSize(width: width, height: width * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if characters.isEmpty {
            let character = loadedCharacters[indexPath.item]
            delegate?.didSelectCharacter(character)
        } else {
            let character = characters[indexPath.item]
            delegate?.didSelectCharacter(character)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              shouldShowMoreIndicator else {
            fatalError("Unsupported")
        }
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                                                                           for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

//MARK: - UIScrollViewDelegate
extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowMoreIndicator,
              !cellViewModels.isEmpty,
              !isLoadingMoreCharacters,
              !isLoadingInitialCharacters,
              let nextUrlString = info?.next,
              let url = URL(string: nextUrlString) else {
            return
        }

        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewHeight = scrollView.frame.size.height

        if offset >= totalContentHeight - totalScrollViewHeight - 120 {
            if !isLoadingMoreCharacters {
                fetchAdtitionalCharacters(url: url)
            }
        }
    }
}
