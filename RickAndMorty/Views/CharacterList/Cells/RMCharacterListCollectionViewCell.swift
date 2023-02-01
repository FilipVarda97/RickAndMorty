//
//  RMCharacterListCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Filip Varda on 25.01.2023..
//

import UIKit

///A view that represents the cell - RMCharacterCollectionViewCell
class RMCharacterListCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.clipsToBounds = true
        containerView.addSubviews(spinner, imageView, nameLabel, statusLabel)
        addConstraints()
        setUpLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    //MARK: - Implementation
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }
    
    private func setUpLayer() {
        containerView.layer.cornerRadius = 10
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOffset = CGSize(width: -2, height: 2)
        contentView.layer.shadowOpacity = 0.6
    }

    private func color(for status: RMCharacterStatus) -> UIColor {
        var color: UIColor
        switch status {
        case .alive:
            color = UIColor.systemGreen
        case .dead:
            color = UIColor.systemRed
        case .unknown:
            color = UIColor.systemYellow
        }
        return color
    }

    private func addConstraints() {
        containerView.snp.makeConstraints { make in
            make.width.height.equalTo(contentView)
        }
        spinner.snp.makeConstraints { make in
            make.center.equalTo(containerView.snp.center)
            make.width.height.equalTo(40)
        }
        imageView.snp.makeConstraints { make in
            make.width.equalTo(containerView)
            make.height.equalTo(imageView.snp.width)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.left.right.equalTo(containerView).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.right.equalTo(containerView).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        }
    }

    public func configureWith(_ viewModel: RMCharacterCollectionViewCellViewModel) {
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = color(for: viewModel.characterStatus).cgColor

        spinner.startAnimating()
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                    self?.spinner.stopAnimating()
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}
