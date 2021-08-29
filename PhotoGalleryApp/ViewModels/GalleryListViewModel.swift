//
//  GalleryListViewModel.swift
//  PhotoGalleryApp
//
//  Created by Usaid Ather on 29/08/2021.
//

import Foundation

protocol GalleryDelegate {
    func didGalleryFetched(vm: [HitsViewModel])
}

class GalleryListViewModel {
    private(set) var galleryViewModels = [HitsViewModel]()
    var delegate: GalleryDelegate?

    func callGalleryAPI(page: Int, searchQuery: String) {
        let searchQuery = searchQuery.isEmpty ? "" : "&q=\(searchQuery)"
        
        let queryParams = "&page=\(page)" + searchQuery
        
        let galleryResource = Resource<GalleryViewModel>(url: URL(string:ApiConstants.APPURL.getPictures + queryParams)!) { data in
            
            print("END POINT:",ApiConstants.APPURL.getPictures + "&page=\(page)" + "&q=\(searchQuery)" )
            
            let galleryVM = try? JSONDecoder().decode(GalleryViewModel.self, from: data)
            return galleryVM
        }
        
        NetworkingAPI().load(resource: galleryResource) { [weak self] result in
            
            if let galleryVM = result {
                if let hitsArray = galleryVM.hits{
                    var tempArray = self?.galleryViewModels
                    tempArray?.append(contentsOf: hitsArray)
                    
                    self?.galleryViewModels =  tempArray ?? []
                    if let delegate = self?.delegate {
                        delegate.didGalleryFetched(vm: self?.galleryViewModels ?? [])
                    }
                }
            }
        }
    }
    
    
    func numberOfRows(_ section: Int) -> Int {
        return self.galleryViewModels.count
    }
    
    func modelAt(_ index: Int) -> HitsViewModel {
        return self.galleryViewModels[index]
    }
    
    func clearGalleryArray(){
        self.galleryViewModels.removeAll()
    }
}

struct GalleryViewModel: Decodable {
    let total : Int?
    let totalHits : Int?
    let hits : [HitsViewModel]?
    
    private enum CodingKeys: String, CodingKey {
        
        case total = "total"
        case totalHits = "totalHits"
        case hits = "hits"
    }
}

struct HitsViewModel: Decodable {
    let id : Int?
    let pageURL : String?
    let type : String?
    let tags : String?
    let previewURL : String?
    let previewWidth : Int?
    let previewHeight : Int?
    let webformatURL : String?
    let webformatWidth : Int?
    let webformatHeight : Int?
    let largeImageURL : String?
    let imageWidth : Int?
    let imageHeight : Int?
    let imageSize : Int?
    let views : Int?
    let downloads : Int?
    let collections : Int?
    let likes : Int?
    let comments : Int?
    let user_id : Int?
    let user : String?
    let userImageURL : String?
    
    private enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case pageURL = "pageURL"
        case type = "type"
        case tags = "tags"
        case previewURL = "previewURL"
        case previewWidth = "previewWidth"
        case previewHeight = "previewHeight"
        case webformatURL = "webformatURL"
        case webformatWidth = "webformatWidth"
        case webformatHeight = "webformatHeight"
        case largeImageURL = "largeImageURL"
        case imageWidth = "imageWidth"
        case imageHeight = "imageHeight"
        case imageSize = "imageSize"
        case views = "views"
        case downloads = "downloads"
        case collections = "collections"
        case likes = "likes"
        case comments = "comments"
        case user_id = "user_id"
        case user = "user"
        case userImageURL = "userImageURL"
    }
}

