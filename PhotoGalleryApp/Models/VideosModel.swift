//
//  Videos.swift
//  PhotoGalleryApp
//
//  Created by Usaid Ather on 29/08/2021.
//

struct VideosModel : Decodable {
    let small : SmallModel?
    
    private enum CodingKeys: String, CodingKey {
        case small = "small"
    }
    
}
