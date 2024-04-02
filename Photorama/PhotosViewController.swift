//
//  ViewController.swift
//  Photorama
//
//  Created by Hamit Sehjal on 2024-04-01.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet private var imageView:UIImageView!
    var store:PhotoStore!

    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchInterestingPhotos()
    }
}
