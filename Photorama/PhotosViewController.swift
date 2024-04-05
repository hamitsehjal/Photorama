//
//  ViewController.swift
//  Photorama
//
//  Created by Hamit Sehjal on 2024-04-01.
//

import UIKit

class PhotosViewController: UIViewController,UICollectionViewDelegate {
    
    
    @IBOutlet  var collectionView:UICollectionView!
    
    var store:PhotoStore!
    
    let photoDataStore=PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource=photoDataStore
        collectionView.delegate=self
        
        store.fetchInterestingPhotos(){
            (photosResult) in
            switch(photosResult){
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                self.photoDataStore.photos = photos
            case let .failure(error):
                print("Error fetching Interesting photos \(error)")
                self.photoDataStore.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataStore.photos[indexPath.row]
        
        // Download the image data, which could take some time
        store.fetchImage(for: photo){
            (result) -> Void in
            // the index path for the photo might have changed between the time the request started and finished, so find the most recent index path

            
            guard let photoIndex = self.photoDataStore.photos.firstIndex(of: photo),case let .success(image) = result else{
                return
            }
            
            let photoItemIndex = IndexPath(item: photoIndex, section: 0)
            
            if let cell =  self.collectionView.cellForItem(at: photoItemIndex) as? PhotoCollectionViewCell{
                cell.update(displayingImage: image)
            }
          
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showPhoto":
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first{
                let item = photoDataStore.photos[selectedIndexPath.row]
                let destination = segue.destination as! PhotoInfoViewController
                destination.photo = item
                destination.store = store
            }
            
        default:
            preconditionFailure("Unexpected Segue Identifier")
        }
    }
    
    
    
    
}
