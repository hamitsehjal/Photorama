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

struct FlickrResponse: Codable{
    let photosInfo: FlickrPhotosResponse
    
    //    mapping preferred property names to key names in JSON
    enum CodingKeys: String, CodingKey{
        case photosInfo =  "photos"
    }
    
}

struct FlickrPhotosResponse: Codable{
    let photos: [Photo]
    
    //    mapping preferred property names to key names in JSON
    enum CodingKeys: String, CodingKey{
        case photos = "photo"
    }
}

struct FlickrAPI{
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "68f9d1eaa59efd2a971ffe6ff2737780"
    private static func flickrURL(endPoint:EndPoint,parameters:[String:String]?) -> URL{
        
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method":endPoint.rawValue,
            "api_key": apiKey,
            "format":"json",
            "nojsoncallback":"1",
            
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
    
    
    static func photos(fromJSON data:Data) -> Result<[Photo],Error>{
        do{
            let decoder = JSONDecoder()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
            
            // filtering image with no urls
            let photos = flickrResponse.photosInfo.photos.filter{
                $0.remoteURL != nil
            }
            return .success(photos)
        }catch{
            return .failure(error)
        }
    }
}
