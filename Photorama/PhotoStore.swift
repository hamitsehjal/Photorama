//
//  PhotoStore.swift
//  Photorama
//
//  Created by Hamit Sehjal on 2024-04-01.
//

import Foundation

class PhotoStore{
    private let session:URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // fetchInterestingPhotos()
    func fetchInterestingPhotos(){
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {
            (data,response,error) in
            
            if let jsonData = data{
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    print(jsonString)
                }
            }
            else if let requestError = error{
                print("Error fetching interesting phots: \(requestError)")
            }
            else{
                print("Unexpected Error with the Request")
            }
            
        }
        task.resume()
    }
}
