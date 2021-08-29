//
//  Small.swift
//  PhotoGalleryApp
//
//  Created by Usaid Ather on 29/08/2021.
//

import Foundation

struct SmallModel : Codable {
    let url : String?
    let width : Int?
    let height : Int?
    let size : Int?
    
    private enum CodingKeys: String, CodingKey {
        
        case url = "url"
        case width = "width"
        case height = "height"
        case size = "size"
    }
    
}
