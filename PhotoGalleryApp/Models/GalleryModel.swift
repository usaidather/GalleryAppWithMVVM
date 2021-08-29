//
//  GalleryViewModel.swift
//  PhotoGalleryApp
//
//  Created by Usaid Ather on 29/08/2021.
//

struct GalleryModel: Decodable {
    let total : Int?
    let totalHits : Int?
    let hits : [HitsViewModel]?
    
    private enum CodingKeys: String, CodingKey {
        
        case total = "total"
        case totalHits = "totalHits"
        case hits = "hits"
    }
}
