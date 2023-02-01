//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Filip Varda on 28.01.2023..
//

import UIKit
import SnapKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterEpisodeCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleContinerView: UIView = {
        let view = UIView()
        view.backgroundColor = RMColors.green1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpConstraints()
        setUpLayer()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }

    private func setUpView() {
        contentView.addSubview(containerView)
        containerView.addSubviews(titleContinerView, seasonLabel, airDateLabel)
        titleContinerView.addSubview(nameLabel)
    }
    
    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.right.left.bottom.equalToSuperview()
        }
        titleContinerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
            
        }
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        }
        seasonLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        airDateLabel.snp.makeConstraints { make in
            make.top.equalTo(seasonLabel.snp.bottom)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setUpLayer() {
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 5
        contentView.layer.borderColor = RMColors.green2.cgColor
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -6, height: 6)
        contentView.layer.shadowOpacity = 0.3
    }

    private func bind() {
        
    }

    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {
        viewModel.episodeObservable.bind { episode in
            guard let episode = episode else {
                return
            }
            self.nameLabel.text = episode.name
            self.airDateLabel.text = "Released at: " + episode.airDate
            self.seasonLabel.text = "Episode: " + episode.episode
        }
        viewModel.fetchEpisode()
    }
}
