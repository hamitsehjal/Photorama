//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Hamit Sehjal on 2024-04-06.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photoID: String?
    @NSManaged public var title: String?
    @NSManaged public var dateTaken: Date?
    @NSManaged public var remoteURL: URL?

}

extension Photo : Identifiable {

}
