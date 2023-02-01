//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Filip Varda on 28.01.2023..
//

import UIKit
import SnapKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterPhotoCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
        setUpLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }

    private func setUpViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        containerView.clipsToBounds = true

        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        
    }
    
    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(containerView.snp.height)
        }
        imageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.equalToSuperview().inset(10)
            make.width.equalTo(imageView.snp.height)
        }
    }

    private func setUpLayer() {
        containerView.layer.cornerRadius = containerView.frame.height / 2
        imageView.layer.cornerRadius = imageView.frame.height / 2
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -8, height: 8)
        contentView.layer.shadowOpacity = 0.3
    }

    public func configure(with viewModel: RMCharacterPhotoCollectionViewCellViewModel) {
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                    self?.setUpLayer()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
