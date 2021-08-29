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

        // Do any additional setup after loading the view.
        
            self.imagePreviewView.loadImageUsingCache(withUrl: imagePreviewURL)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
