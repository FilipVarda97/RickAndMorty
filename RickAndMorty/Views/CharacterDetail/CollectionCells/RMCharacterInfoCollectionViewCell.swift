//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Filip Varda on 28.01.2023..
//

import UIKit
import SnapKit

class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterInfoCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage().withRenderingMode(.alwaysTemplate)
        icon.tintColor = .black
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
        setUpLayer()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
    }

    private func setUpViews() {
        contentView.addSubview(containerView)
        titleLabel.textAlignment = .center
        valueLabel.textAlignment = .center
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        titleContainer.backgroundColor = RMColors.green1
        
        containerView.addSubviews(titleContainer, valueLabel)
        titleContainer.addSubviews(iconImageView, titleLabel)
    }

    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(contentView)
        }
        titleContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(titleContainer.snp.height)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.right.centerY.equalTo(titleContainer)
        }
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleContainer.snp.bottom)
            make.left.bottom.right.equalTo(contentView)
        }
    }
    
    private func setUpLayer() {
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -6, height: 6)
        contentView.layer.shadowOpacity = 0.3
    }


    public func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.displayValue
        iconImageView.image = viewModel.iconImage
    }
}
