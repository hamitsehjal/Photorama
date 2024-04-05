//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Hamit Sehjal on 2024-04-04.
//


import UIKit

class PhotoDataSource:NSObject,UICollectionViewDataSource{
    
    var photos=[Photo]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        
        cell.update(displayingImage: nil)
        return cell
    }
    
    
}
