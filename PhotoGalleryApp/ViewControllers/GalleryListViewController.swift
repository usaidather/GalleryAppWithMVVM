//
//  GalleryListViewController.swift
//  PhotoGalleryApp
//
//  Created by Usaid Ather on 29/08/2021.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class GalleryListViewController: UIViewController {
    
    @IBOutlet weak var gallerySegmentControll: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var galleryListTableView: UITableView!
    
    private var galleryListViewModel = GalleryListViewModel()
    private var datasource: TableViewDataSource<GalleryTableViewCell,HitsViewModel>!
    
    private var page: Int = 1
    private var didDataEnd: Bool = false
    private var isDataLoading: Bool = false
    
    // default initializer...
    private func setValuesToDefault() {
        self.page = 1
        self.didDataEnd = false
        self.isDataLoading = false
        
        // first clearing out viewmodel data and assigning it to data source.
        self.galleryListViewModel.clearGalleryArray()
        self.datasource.updateItems(self.galleryListViewModel.galleryViewModels)
        DispatchQueue.main.async {
            self.galleryListTableView.reloadData()
        }
    }
    
    //MARK:- ViewController LifeCycle Method.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // delegate methods
        self.galleryListViewModel.delegate = self
        self.searchBar.delegate = self
        
        // calling an api with default initializer to fetch images.
        self.galleryListViewModel.callGalleryAPI(page: page, searchQuery: "", mediaType: self.gallerySegmentControll.selectedSegmentIndex)
        self.isDataLoading = true
        
        
        // filling up with data source then assigning it the tableview data source..
        self.datasource = TableViewDataSource(cellIdentifier: "GalleryCell", items: self.galleryListViewModel.galleryViewModels) { cell, vm in
            
            cell.configure(vm, mediaType: self.gallerySegmentControll.selectedSegmentIndex)
        }
        
        self.galleryListTableView.dataSource = self.datasource
    }
    
    // MARK:- Search Function
    // search Functionality
    @objc func searchInGallery() {
        self.setValuesToDefault()
        
        self.galleryListViewModel.callGalleryAPI(page: page, searchQuery: self.searchBar.text ?? "", mediaType: self.gallerySegmentControll.selectedSegmentIndex)
        
    }
    
    // MARK:- IBActions
    //segment controll functionality to show data wrt to selection of image or video
    @IBAction func segmentControlIndexChanged(_ sender: Any) {
        self.setValuesToDefault()
        
        switch self.gallerySegmentControll.selectedSegmentIndex
        {
        // if its image
        case 0:
            self.galleryListViewModel.callGalleryAPI(page: page, searchQuery: "", mediaType: self.gallerySegmentControll.selectedSegmentIndex)
        // if its video
        case 1:
            self.galleryListViewModel.callGalleryAPI(page: page, searchQuery: "", mediaType: self.gallerySegmentControll.selectedSegmentIndex)
            
        default:
            break;
        }
    }
}

//MARK:- GalleryDelegate
// delegate method to notify when data is fetched from API call present at GalleryListViewmodel
extension GalleryListViewController: GalleryDelegate {
    func didGalleryFetched(vm: [HitsViewModel]) {
        
        self.datasource.updateItems(self.galleryListViewModel.galleryViewModels)
        
        self.isDataLoading = false
        self.didDataEnd = vm.count > 0 ? false: true
        
        DispatchQueue.main.async {
            self.galleryListTableView.reloadData()
        }
    }
}

// MARK:- UITableViewDelegate
extension GalleryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if we have tapped on image item then navigate to preview vc
        if(self.gallerySegmentControll.selectedSegmentIndex == 0) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ImagePreviewViewController") as? ImagePreviewViewController
            vc?.imagePreviewURL = self.galleryListViewModel.modelAt(indexPath.row).largeImageURL ?? ""
            
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }else{
            // if we have tapped to video item then navigate to video preview VC
            let videoURL =  URL(string: self.galleryListViewModel.modelAt(indexPath.row).video?.small?.url ?? "")
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    // handling pagination here
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastElement = self.galleryListViewModel.galleryViewModels.count - 1
        
        // checking if the element is last and data is not loading and we have not recieved a empty data.
        if indexPath.row == lastElement && !self.isDataLoading && !self.didDataEnd {
            self.page += 1
            self.isDataLoading = true
            galleryListViewModel.callGalleryAPI(page: self.page, searchQuery: self.searchBar.text ?? "", mediaType: self.gallerySegmentControll.selectedSegmentIndex)
        }
    }
}

//MARK:- UISearchBarDelegate
// A UISearchBar delegate method to apply search functionality to this app.
//adding 0.5s of delay to network call request to apply search realtime.
extension GalleryListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // to limit network activity, reload half a second after last key press.
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchInGallery), object: nil)
        self.perform(#selector(self.searchInGallery), with: nil, afterDelay: 0.5)
        
    }
}
