//
//  GalleryListViewController.swift
//  PhotoGalleryApp
//
//  Created by Usaid Ather on 29/08/2021.
//

import Foundation
import UIKit

class GalleryListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var galleryListTableView: UITableView!
    
    private var galleryListViewModel = GalleryListViewModel()
    private var datasource: TableViewDataSource<GalleryTableViewCell,HitsViewModel>!
    
    private var page: Int = 1
    private var didDataEnd: Bool = false
    private var isDataLoading: Bool = false
    
    private func setValuesToDefault() {
        self.page = 1
        self.didDataEnd = false
        self.isDataLoading = false
        self.galleryListViewModel.clearGalleryArray()
        self.datasource.updateItems(self.galleryListViewModel.galleryViewModels)
        DispatchQueue.main.async {
            self.galleryListTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.galleryListViewModel.delegate = self
        self.searchBar.delegate = self
        
        self.galleryListViewModel.callGalleryAPI(page: page, searchQuery: "")
        self.isDataLoading = true
        
        
        self.datasource = TableViewDataSource(cellIdentifier: "GalleryCell", items: self.galleryListViewModel.galleryViewModels) { cell, vm in
            
            cell.configure(vm)
        }
        
        self.galleryListTableView.dataSource = self.datasource
    }
    
    @objc func searchInGallery() {
        self.setValuesToDefault()
        
        self.galleryListViewModel.callGalleryAPI(page: page, searchQuery: self.searchBar.text ?? "")
        
    }
}

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

extension GalleryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastElement = self.galleryListViewModel.galleryViewModels.count - 1
        
        if indexPath.row == lastElement && !self.isDataLoading && !self.didDataEnd {
            self.page += 1
            self.isDataLoading = true
            galleryListViewModel.callGalleryAPI(page: self.page, searchQuery: self.searchBar.text ?? "")
        }
    }
}

extension GalleryListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // to limit network activity, reload half a second after last key press.
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchInGallery), object: nil)
        self.perform(#selector(self.searchInGallery), with: nil, afterDelay: 0.5)
        
    }
}
