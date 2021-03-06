//
//  Constants.swift
//  PhotoGalleryApp
//
//  Created by Usaid Ather on 29/08/2021.
//

import UIKit

class ApiConstants: NSObject {
    struct APPURL {
        
        private struct Domains {
            static let live = "https://pixabay.com"
        }
        
        private  struct Routes {
            static let Api = "/api/"
        }
        
        private static var Domain: String {
            return Domains.live
        }
        
        private static var Key: String {
            let key = AppConstants.API_KEY
            return "?key=\(key)"
        }
        
        
        private  static let Route = Routes.Api
        private  static let BaseURL = Domain + Route + Key
      
//        https://pixabay.com/api/videos/?key=23138726-37bfff9226ef4bfb6e0a97fe3&q=yellow+flowers

        private static let VideoBaseURL = Domain + Route + "videos/" + Key
        
        static let getPictures = BaseURL
        static let getVideos = VideoBaseURL
    }
}
