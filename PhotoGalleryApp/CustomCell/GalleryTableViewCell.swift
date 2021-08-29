//
//  GalleryTableViewCell.swift
//  PhotoGalleryApp
//
//  Created by Usaid Ather on 29/08/2021.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoPlayImageView: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var galleryImageView: UIImageView!
    
    // population cell view wrt video or image segment selection.
    func configure(_ vm: HitsViewModel, mediaType: Int) {
        switch mediaType {
        case 0:
            self.videoPlayImageView.isHidden = true
            self.galleryImageView.isHidden = false
            
            if let imageURL = vm.webformatURL {
                self.galleryImageView.loadImageUsingCache(withUrl: imageURL)
                // showing dynamic height wrt to image height given in response.
                self.imageHeightConstraint.constant = CGFloat(Float(vm.previewHeight ?? 0))
            }
            
        case 1:
            self.videoPlayImageView.isHidden = false
            self.galleryImageView.isHidden = true
            
        default:
            self.videoPlayImageView.isHidden = true
            self.galleryImageView.isHidden = true
        }
        viewsLabel.text = "\(vm.views ?? 0) Views"
        likesLabel.text = "\(vm.likes ?? 0) Likes"
        commentsLabel.text = "\(vm.comments ?? 0) Comments"
    }
}
