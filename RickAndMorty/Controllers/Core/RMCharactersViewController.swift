//
//  RMCharactersViewController.swift
//  RickAndMorty
//
//  Created by Filip Varda on 25.01.2023..
//

import UIKit
import SnapKit

///A view controller responsible for presenting RMCharacterListView and navigation handling
class RMCharactersViewController: UIViewController {
    private let characterListView = RMCharacterListView(frame: .zero,
                                                        type: .server)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Characters"
        setUpView()
    }

    //MARK: - Implementation
    private func setUpView() {
        characterListView.delegate = self
        view.addSubview(characterListView)
        characterListView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - RMCharacterListViewDelegate
extension RMCharactersViewController: RMCharacterListViewDelegate {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

