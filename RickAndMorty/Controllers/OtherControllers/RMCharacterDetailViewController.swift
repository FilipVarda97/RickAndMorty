//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Filip Varda on 26.01.2023..
//

import UIKit

///A view controller responsible for presenting RMCharacterDetailView and navigation handling
final class RMCharacterDetailViewController: UIViewController {
    private let detailView: RMCharacterDetailView
    private let viewModel: RMCharacterDetailViewViewModel
    
    // MARK: - Init
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapShare))
        detailView.delegate = self
        viewModel.checkForCharacterInCoreDate()
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc
    private func didTapShare() {
        viewModel.saveCharacterToCoreData { [weak self] result in
            switch result {
            case .success:
                self?.viewModel.checkForCharacterInCoreDate()
            case .failure(let error):
                print(error)
            }
        }
    }

    @objc
    private func didTapDelete() {
        viewModel.deleteCharacterFromCoreData { [weak self] result in
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - RMCharacterDetailViewDelegate
extension RMCharacterDetailViewController: RMCharacterDetailViewDelegate {
    func rmCharacterDetailView(_ characterDetailView: RMCharacterDetailView, shouldEnableDelete: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "minus.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapDelete))
    }
    
    func rmCharacterDetailView(_ characterDetailView: RMCharacterDetailView, didSelectEpisode episode: RMEpisode) {
        //TODO: Show episode detail
    }
}
