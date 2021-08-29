//
//  GalleryListViewModel.swift
//  PhotoGalleryApp
//
//  Created by Usaid Ather on 29/08/2021.
//

import Foundation
// delegate protocal to notify when data is fetched
protocol GalleryDelegate {
    func didGalleryFetched(vm: [HitsViewModel])
}

class GalleryListViewModel {
    private(set) var galleryViewModels = [HitsViewModel]()
    var delegate: GalleryDelegate?
    
    // API call to fetch data
    func callGalleryAPI(page: Int, searchQuery: String, mediaType: Int) {
        let baseURL = (mediaType == 0) ? ApiConstants.APPURL.getPictures : ApiConstants.APPURL.getVideos
        
        let searchQuery = searchQuery.isEmpty ? "" : "&q=\(searchQuery)"
        let queryParams = "&page=\(page)" + searchQuery
        
        let galleryResource = Resource<GalleryModel>(url: URL(string:baseURL + queryParams)!) { data in
            
            let galleryVM = try? JSONDecoder().decode(GalleryModel.self, from: data)
            return galleryVM
        }
        
        NetworkingAPI().load(resource: galleryResource) { [weak self] result in
            
            if let galleryVM = result {
                if let hitsArray = galleryVM.hits{
                    //                    to handle pagination
                    var tempArray = self?.galleryViewModels
                    tempArray?.append(contentsOf: hitsArray)
                    
                    self?.galleryViewModels =  tempArray ?? []
                    // notifying VCs when data is fetched
                    if let delegate = self?.delegate {
                        delegate.didGalleryFetched(vm: self?.galleryViewModels ?? [])
                    }
                }
            }
        }
    }
    
    // supporting methods
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









