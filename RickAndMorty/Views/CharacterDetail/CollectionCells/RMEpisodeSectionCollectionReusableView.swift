//
//  RMEpisodeSectionCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Filip Varda on 31.01.2023..
//

import UIKit
import SnapKit

///A view that represents the episode section view in RMCharacterDetailViewController 
class RMEpisodeSectionCollectionReusableView: UICollectionReusableView {
    static let identifier = "RMEpisodeSectionCollectionReusableView"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Episodes"
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("Unspopprted")
    }

    //MARK: - Implementation
    private func addConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.centerY.equalTo(self)
        }
    }

    public func configure(with count: Int) {
        print(count)
    }
}
