//
//  UIViewController.swift
//  PhotoGalleryApp
//
//  Created by Usaid Ather on 29/08/2021.
//

import Foundation
import UIKit
// A handy extension for UI View Controller to handle tap gesture to dismiss kkeyboard.
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
