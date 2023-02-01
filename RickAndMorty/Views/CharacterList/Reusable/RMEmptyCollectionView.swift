//
//  RMEmptyCollectionView.swift
//  RickAndMorty
//
//  Created by Filip Varda on 01.02.2023..
//

import UIKit
import SnapKit

/// A view that appears if UICollectionView has no data
class RMEmptyCollectionView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .systemGray3
        label.textAlignment = .center
        label.text = "No data to show"
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("Unspopprted")
    }
    
    private func setUpViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.right.equalToSuperview()
        }
    }
}
