//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Filip Varda on 28.01.2023..
//

import Foundation
import UIKit

/// ViewModel that manages RMCharacterInfoCollectionViewCell logic
final class RMCharacterInfoCollectionViewCellViewModel {
    enum `Type` {
        case name
        case species
        case gender
        case status
        case createdAt
        case origin

        var title: String {
            switch self {
            case .name:
                return "Name"
            case .species:
                return "Species"
            case .gender:
                return "Gender"
            case .status:
                return "Status"
            case .createdAt:
                return "Create At"
            case .origin:
                return "Origin"
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .name:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .status:
                return UIImage(systemName: "bell")
            case .createdAt:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            }
        }
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = .current
        return formatter
    }()

    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    private let type: `Type`
    private var value: String
    
    // MARK: - Computed
    public var title: String {
        return type.title
    }
    
    public var iconImage: UIImage? {
        return type.icon
    }

    public var displayValue: String {
        if value.isEmpty {
            return "No info"
        }

        if let date = Self.dateFormatter.date(from: value), type == .createdAt {
            return Self.shortDateFormatter.string(from: date)
        }

        return value
    }
    
    // MARK: - Init
    init(type: `Type`,  value: String) {
        self.type = type
        self.value = value
    }
}
