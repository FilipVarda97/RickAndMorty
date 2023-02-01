//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Filip Varda on 26.01.2023..
//

import UIKit
import CoreData

protocol RMCharacterDetailViewViewModelDelegate: AnyObject {
    func didSelectEpisode(_ episode: RMEpisode)
    func enableDeleteCharacterButton()
}

/// ViewModel that manages RMCharacterDetailView logic
final class RMCharacterDetailViewViewModel: NSObject {
    enum SectionType {
        case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModel)
        case information(viewModels: [RMCharacterInfoCollectionViewCellViewModel])
        case episodes(viewModels: [RMCharacterEpisodeCollectionViewCellViewModel])
    }

    private var character: RMCharacter?
    public var sections: [SectionType] = []
    weak var delegate: RMCharacterDetailViewViewModelDelegate?
    
    // MARK: - Init
    override init() {
        super.init()
        self.character = nil
        setUpSections()
    }

    convenience init(character: RMCharacter) {
        self.init()
        self.character = character
        setUpSections()
    }

    public var title: String {
        guard let title = character?.name.uppercased() else {
            return ""
        }
        return title
    }

    private var requestUrl: URL? {
        guard let urlString = character?.url else {
            return nil
        }
        return URL(string: urlString)
    }
    
    // MARK: - Implementation
    private func setUpSections() {
        guard let character = character else {
            return
        }
        sections = [
            .photo(viewModel: .init(imageUrl: URL(string: character.image))),
            .information(viewModels: [
                .init(type: .name, value: character.name),
                .init(type: .species, value: character.species),
                .init(type: .gender, value: character.gender.rawValue),
                .init(type: .status, value: character.status.text),
                .init(type: .createdAt, value: character.created),
                .init(type: .origin, value: character.origin.name)
            ]),
            .episodes(viewModels: character.episode.compactMap({
                return .init(episodeDataUrl: URL(string: $0))
            }))
        ]
    }

    // MARK: - LayoutSetUp
    public func createPhotoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.4)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }

    public func createInfoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item, item]
        )

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    public func createEpisodeSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension RMCharacterDetailViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(viewModels: let viewModels):
            return viewModels.count
        case .episodes(viewModels: let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .photo(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterPhotoCollectionViewCell.identifier,
                                                                for: indexPath) as? RMCharacterPhotoCollectionViewCell else {
                fatalError("Ups, missing cell")
            }
            cell.configure(with: viewModel)
            return cell
        case .information(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterInfoCollectionViewCell.identifier,
                                                                for: indexPath) as? RMCharacterInfoCollectionViewCell else {
                fatalError("Ups, missing cell")
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .episodes(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier,
                                                                for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
                fatalError("Ups, missing cell")
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .photo:
            break
        case .information:
            break
        case .episodes(viewModels: let viewModels):
            let viewModel = viewModels[indexPath.row]
            guard let episode = viewModel.episodeObservable.value else { return }
            delegate?.didSelectEpisode(episode)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sections = sections[indexPath.section]
        switch sections {
        case .information, .photo:
            break
        case .episodes(viewModels: let viewModels):
            guard kind == UICollectionView.elementKindSectionHeader else {
                fatalError("Unsupported")
            }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: RMEpisodeSectionCollectionReusableView.identifier,
                                                                               for: indexPath) as? RMEpisodeSectionCollectionReusableView else {
                fatalError("Unsupported")
            }
            header.configure(with: viewModels.count)
            return header
        }
        return UICollectionReusableView()
    }
}


// MARK: - CoreData
extension RMCharacterDetailViewViewModel {
    /// Searches for character loaded in this ViewModel in CoreData.
    /// If the character already exists, tell the delegate to enable delete button
    public func checkForCharacterInCoreDate() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let character = character else { return }

        let managedObjectContext = appDelegate.persistentContainer.viewContext
        do {
            let request = RMCharacterEntity.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@", character.name)
            let count = try managedObjectContext.count(for: request)
            if count > 0 {
                delegate?.enableDeleteCharacterButton()
                return
            }
        } catch let error as NSError {
            print("Error saving context: \(error), \(error.userInfo)")
        }
    }

    /// Saves for character loaded in this ViewModel in CoreData.
    public func saveCharacterToCoreData(completion: @escaping(Result<String?, Error>) -> Void) {
        guard let character = character,
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        guard let newEntity = NSEntityDescription.insertNewObject(forEntityName: "RMCharacterEntity",
                                                                  into: managedObjectContext) as? RMCharacterEntity else {
            return
        }

        newEntity.setValue(character.id, forKey: "id")
        newEntity.setValue(character.name, forKey: "name")
        newEntity.setValue(character.status.rawValue, forKey: "status")
        newEntity.setValue(character.species, forKey: "species")
        newEntity.setValue(character.type, forKey: "type")
        newEntity.setValue(character.gender.rawValue, forKey: "gender")
        newEntity.setValue(character.origin.url, forKey: "origin")
        newEntity.setValue(character.location.url, forKey: "location")
        newEntity.setValue(character.image, forKey: "image")
        newEntity.setValue(character.episode.first, forKey: "episode")
        newEntity.setValue(character.url, forKey: "url")
        newEntity.setValue(character.created, forKey: "created")
        
        do {
            try managedObjectContext.save()
            completion(.success(character.name))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    func deleteCharacterFromCoreData(completion: @escaping(Result<String?, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let character = character else { return }

        let managedObjectContext = appDelegate.persistentContainer.viewContext
        do {
            let request = RMCharacterEntity.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@", character.name)
            let results = try managedObjectContext.fetch(request)
            for result in results {
                managedObjectContext.delete(result)
            }
            try managedObjectContext.save()
            completion(.success(character.name))
        } catch let error as NSError {
            print("Error saving context: \(error), \(error.userInfo)")
            completion(.failure(error))
        }
    }
}

