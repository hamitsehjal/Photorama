//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Hamit Sehjal on 2024-04-01.
//

import Foundation

enum EndPoint:String{
    case interestingPhotos = "flickr.interestingness.getList"
}
struct FlickrAPI{
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "68f9d1eaa59efd2a971ffe6ff2737780"
    private static func flickrURL(endPoint:EndPoint,parameters:[String:String]?) -> URL{
        
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method":endPoint.rawValue,
            "format":"json",
            "nojsoncallback":"1",
            "api_key": apiKey
        ]
        for (key,val) in baseParams{
            let item = URLQueryItem(name: key, value: val)
            queryItems.append(item)
        }
        if let additionalParameters = parameters{
            for (key,val) in additionalParameters{
                let item = URLQueryItem(name: key, value: val)
                queryItems.append(item)
            }
        }
        
        components.queryItems=queryItems
        
        return components.url!
    }
    
    static var interestingPhotosURL:URL{
        return flickrURL(endPoint: .interestingPhotos, parameters: ["extras":"url_z,date_taken"])
    }
}
