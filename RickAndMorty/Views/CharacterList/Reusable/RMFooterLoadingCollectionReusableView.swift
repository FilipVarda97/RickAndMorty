//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Filip Varda on 26.01.2023..
//

import UIKit
import SnapKit

///A view that represents the spinner at the bottom of RMCharacterListView collectionView
class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "RMFooterLoadingCollectionReusableView"
    private let spinner = UIActivityIndicatorView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        addConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("Unspopprted")
    }

    //MARK: - Implementation
    public func startAnimating() {
        spinner.startAnimating()
    }
    
    private func addConstraints() {
        spinner.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.centerY.equalTo(self)
        }
    }
}
