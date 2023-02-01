//
//  RMSavedCharactersViewController.swift
//  RickAndMorty
//
//  Created by Filip Varda on 31.01.2023..
//

import UIKit

class RMSavedCharactersViewController: UIViewController {
    private let characterListView = RMCharacterListView(frame: .zero,
                                                        type: .localStorage)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved Characters"
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

    override func viewWillAppear(_ animated: Bool) {
        // TODO: Create an action for update instead of calling it on viewWillAppear()
        characterListView.updateFromLocalStorage()
    }
}

//MARK: - RMCharacterListViewDelegate
extension RMSavedCharactersViewController: RMCharacterListViewDelegate {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
