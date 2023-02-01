//
//  RMCharacterEntity+CoreDataProperties.swift
//  
//
//  Created by Filip Varda on 31.01.2023..
//
//

import Foundation
import CoreData


extension RMCharacterEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RMCharacterEntity> {
        return NSFetchRequest<RMCharacterEntity>(entityName: "RMCharacterEntity")
    }

    @NSManaged public var gender: String?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var species: String?
    @NSManaged public var status: String?
    @NSManaged public var type: String?
    @NSManaged public var origin: String?
    @NSManaged public var location: String?
    @NSManaged public var image: String?
    @NSManaged public var episode: String?
    @NSManaged public var url: String?
    @NSManaged public var created: String?

}
