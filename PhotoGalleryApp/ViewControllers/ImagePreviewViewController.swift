//
//  ImagePreviewViewController.swift
//  PhotoGalleryApp
//
//  Created by Usaid Ather on 29/08/2021.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    var imagePreviewURL: String = ""
    @IBOutlet weak var imagePreviewView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePreviewView.loadImageUsingCache(withUrl: imagePreviewURL)
        
    }
}
