//
//  PhotoStore.swift
//  Photorama
//
//  Created by Hamit Sehjal on 2024-04-01.
//


import UIKit
import CoreData
class PhotoStore{
    
    let persistentContainer:NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores(completionHandler: {(description,error) in
            if let error = error{
                print("Error setting up the Core Data \(error)")
            }})
        return container
    }()
    
    enum PhotoError:Error{
        case imageCreationError
        case missingImageURL
    }
    
    private let session:URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // fetchInterestingPhotos()
    func fetchInterestingPhotos(completion: @escaping (Result<[Photo],Error>)-> Void){
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {
            (data,response,error) in
            
            var result = self.processPhotosRequest(data: data, error: error)
            if case .success = result{
                do{
                    try self.persistentContainer.viewContext.save()
                }catch{
                    result = .failure(error)
                }
            }
            OperationQueue.main.addOperation{
                completion(result)
            }
           
        }
        task.resume()
    }
    
    // download an image
    func fetchImage(for photo:Photo, completion: @escaping (Result<UIImage,Error>)->Void){
        
        guard let photoURL = photo.remoteURL else{
            completion(.failure(PhotoError.missingImageURL))
            return
        }
        let request = URLRequest(url: photoURL)
        let task = session.dataTask(with: request){
            (data,response,error) in
            
            let result = self.processImageRequest(data: data, error: error)
            
            // forcing the completion handler to run on Main thread
            OperationQueue.main.addOperation{
                completion(result)
            }
        }
        task.resume()
    }
    
    // process json data returned from web service request
    private func processPhotosRequest(data:Data?,error:Error?)->Result<[Photo],Error>{
        
        guard let jsonData = data else{
            return .failure(error!)
        }

        let context = persistentContainer.viewContext
        
        // try parsing the JSON data to FlickrPhoto Model
        switch FlickrAPI.photos(fromJSON: jsonData){
        case let .success(flickrPhotos):
            let photos = flickrPhotos.map{(flickrPhoto) -> Photo in
                
                // make a fetch request to check if the photo already exists in the Context
                // if it does, return that
                // otherwise, save it to the context
                let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
                let predicate = NSPredicate(format: "\(#keyPath(Photo.photoID)) == \(flickrPhoto.photoID)")
                fetchRequest.predicate=predicate
                
                var fetchedPhotos:[Photo]?
                context.performAndWait {
                        fetchedPhotos = try? fetchRequest.execute()
                }
                if let existingPhoto = fetchedPhotos?.first{
                    return existingPhoto
                }
                
                var photo:Photo!
                context.performAndWait{
                    photo = Photo(context: context)
                    photo.photoID=flickrPhoto.photoID
                    photo.title=flickrPhoto.title
                    photo.remoteURL=flickrPhoto.remoteURL
                    photo.dateTaken=flickrPhoto.dateTaken
                }
                return photo
            }
            return .success(photos)
        case let .failure(error):
            return .failure(error)
        }
        
        
    }
    
    // Create an UIImage instance from the requst data
    private func processImageRequest(data: Data?,error:Error?)->Result<UIImage,Error>{
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else{
            
            // couldn't create an image
            if data == nil{
                return .failure(error!)
            }
            else{
                return .failure(PhotoError.imageCreationError)
            }
            
        }
        
        return .success(image)
    }
    
    // fetch all the photos from Core Data (Photo Entity)
    func fetchAllPhotos(completion: @escaping (Result<[Photo],Error>) -> Void){
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDateTaken:NSSortDescriptor = NSSortDescriptor(key: #keyPath(Photo.dateTaken), ascending: false)
        fetchRequest.sortDescriptors = [sortByDateTaken]
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do{
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
            }catch{
                completion(.failure(error))
            }
            
        }
    }
}
