//
//  EntireController.swift
//  Portocal
//
//  Created by Eric on 2019/10/16.
//  Copyright © 2019 Watashi NNWU Ltd. All rights reserved.
//

import UIKit

class EntireController: UIViewController {

    var inSearchMode = false
    var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBarButton()
    }
    
    @objc func showSearchBar() {
        configureSearchBar(shouldShow: true)
    }
    
    func configureSearchBarButton() {
        navigationController?.navigationBar.barTintColor = .darkOrange()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        configureSearchBar(shouldShow: true)
    }
    
    func configureSearchBar(shouldShow: Bool) {
        if shouldShow {
            searchBar = UISearchBar()
            searchBar.delegate = self
            searchBar.sizeToFit()
            searchBar.showsCancelButton = true
            searchBar.becomeFirstResponder()
            searchBar.tintColor = .white
            self.searchBar.endEditing(true)
            
            navigationItem.rightBarButtonItem = nil
            navigationItem.titleView = searchBar
        } else {
            navigationItem.titleView = nil
            navigationController?.navigationBar.tintColor = .white
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
            inSearchMode = false
        }
    }
}

extension EntireController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let selVC = HomeController()
        present(UINavigationController(rootViewController: selVC), animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // hides the keyboard
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            view.endEditing(true)
        } else {
            inSearchMode = true
        }
    }
}
