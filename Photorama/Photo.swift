//
//  Photo.swift
//  Photorama
//
//  Created by Hamit Sehjal on 2024-04-01.
//

import Foundation

class Photo: Codable,Equatable{
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        // Two photos are same if they have same PhotoID
        return lhs.photoID == rhs.photoID
    }
    
    let photoID:String
    let title:String
    let remoteURL: URL?
    let dateTaken: Date
    
//    mapping preferred property names to key names in JSON
    enum CodingKeys: String,CodingKey{
        case photoID = "id"
        case dateTaken = "datetaken"
        case remoteURL = "url_z"
        case title
    }
    
   
}
