//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Hamit Sehjal on 2024-04-04.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var spinner:UIActivityIndicatorView!
    
    
    func update(displayingImage:UIImage?){
        if let image=displayingImage{
            // stop the spinner
            spinner.stopAnimating()
            imageView.image=image
        }else{
            // start the spinner
            spinner.startAnimating()
            imageView.image=nil
        }
    }
}
