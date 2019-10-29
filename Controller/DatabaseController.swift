//
//  SettingsController.swift
//  Portocal
//
//  Created by Stamate Iulian Stancu on 29/09/2019.
//  Copyright © 2019 Watashi NNWU Ltd. All rights reserved.
//

import UIKit
import Network
import Firebase
import ProgressHUD

private let reuseIdentifier = "PortocalCell"

class DatabaseController: UIViewController {
    
    
    // MARK - Properties
    
    var refPortocal: DatabaseReference!// firebase database reference
    var portocalList = [Portocal]()
    var filteredPortocal = [Portocal]()
    var portocalData = [PortocalData]()
    var inSearchMode = false
    var searchBar = UISearchBar()
    
    var navTitle = "Main Feed"
    var searchKey: String = ""
    var isCategorySearch = false
    var isCitySearch = false
    var pPageID = 0
    var lastFetchedKey = "\(1)"
    var idx = 0
    let infoView: InfoView = {
        let view = InfoView()
        //view.layer.cornerRadius = 5
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    let dataCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PortocalCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressHUD.show()
        refPortocal = Database.database().reference().child("portocal")
        configureUI()
        portocalList.removeAll()
        if isCategorySearch == true {
            fetchValuesFromFirebaseByCategory(keyword: searchKey)
        } else {
            fetchValuesFromFirebase()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navTitle == "Search by City" && inSearchMode == true {
            showSearchBar()
        }
    }
    
    
    //MARK: - Selectors
    
    @objc func handleDismiss() {
        ProgressHUD.dismiss()
        isCategorySearch = false
        searchKey = ""
        pPageID = 0
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showSearchBar() {
        configureSearchBar(shouldShow: true)
    }
    
    @objc func handleDismissal() {
        dismissInfoView(portocal: nil)
    }
    
    //MARK - API
    
    // Fetching Values from Firebase
    func fetchValuesFromFirebase() {
        //observing the data changes
        refPortocal.queryOrderedByKey()
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
                //if the reference have some values
                if snapshot.childrenCount > 0 {
                    
                    //clearing the list
                    //iterating through all the values
                    for portocals in snapshot.children.allObjects as! [DataSnapshot] {
                        //getting values
                        let portocalObject = portocals.value as? [String: AnyObject]
                        
                        //creating artist object with model and fetched values
                        let oneData = PortocalData(idx: self.idx, dictionary: portocalObject!)
                        self.portocalData.append(oneData)
//                        print("\(self.idx)")
                        self.idx += 1
                    }
                    
                    if self.isCitySearch {
                        self.loadAllPortocalData()
                    } else {
                        self.loadPortocalData(pageId: self.pPageID)
                    }
                }
            })
    }

    func fetchValuesFromFirebaseByCategory(keyword: String) {
        //observing the data changes
        refPortocal.queryOrdered(byChild: keyword)
            .queryStarting(atValue: lastFetchedKey)
            .observe(DataEventType.value, with: { (snapshot) in
                
                //if the reference have some values
                if snapshot.childrenCount > 0 {
                    
                    //clearing the list
                    //iterating through all the values
                    for portocals in snapshot.children.allObjects as! [DataSnapshot] {
                        //getting values
                        let portocalObject = portocals.value as? [String: AnyObject]
                        
                        //creating artist object with model and fetched values
                        let oneData = PortocalData(idx: self.idx, dictionary: portocalObject!)
                        self.portocalData.append(oneData)
//                        print("\(self.idx)")
                        //appending it to list
                        self.idx += 1
                    }
                    
                    //reloading the dataCV
                    self.lastFetchedKey = "\(self.idx)"
                    self.loadPortocalData(pageId: self.pPageID)
                }
            })
    }
    
    func loadAllPortocalData() {
        var i = 0
        while( i < portocalData.count ) {
            let onePorto = Portocal(id: i, dictionary: portocalData[i].dic)
            self.portocalList.append(onePorto)
            i += 1
        }
        ProgressHUD.dismiss()
    }
    
    func loadPortocalData(pageId: Int) {
        var i = 0
        if pageId * 8 < portocalData.count {
            var limit = 8
            if (pageId + 1) * 8 > portocalData.count {
                limit = portocalData.count - (pageId * 8)
            }
            while( i < limit ) {
                let onePorto = Portocal(id: pageId * 8 + i, dictionary: portocalData[pageId * 8 + i].dic)
                self.portocalList.append(onePorto)
                i += 1
            }
            self.pPageID += 1
            self.dataCV.reloadData()
        }
        ProgressHUD.dismiss()
    }

    // MARK: - Helper Functions
    
    func showPortocalInfoController(withPortocal portocal: Portocal) {
        let controller = PortocalInfoController()
        controller.portocal = portocal
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func configureSearchBar(shouldShow: Bool) {
        
        if shouldShow {
            searchBar = UISearchBar()
            searchBar.delegate = self
            searchBar.sizeToFit()
            searchBar.showsCancelButton = true
            searchBar.becomeFirstResponder()
            searchBar.tintColor = .lightGray
            self.searchBar.endEditing(true)
            
            navigationItem.rightBarButtonItem = nil
            navigationItem.titleView = searchBar
        } else {
            navigationItem.titleView = nil
            configureSearchBarButton()
            inSearchMode = false
            ProgressHUD.dismiss()
            dataCV.reloadData()
        }
    }
    
    func configureSearchBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func configureCollectionView() {
        view.addSubview(dataCV)
        dataCV.delegate = self
        dataCV.dataSource = self
        dataCV.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        dataCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        dataCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        dataCV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        dataCV.delegate = self
        dataCV.dataSource = self
    }
    
    func dismissInfoView(portocal: Portocal?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.infoView.alpha = 0
            self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.infoView.removeFromSuperview()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            guard let portocal = portocal else { return }
            self.showPortocalInfoController(withPortocal: portocal)
        }
    }
    
    func configureUI() {
        view.contentMode = UIView.ContentMode.scaleAspectFill
        navigationController?.navigationBar.barTintColor = .darkOrange()
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = navTitle
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "white-down-arrow-png-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        configureSearchBarButton()
        configureCollectionView()
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        visualEffectView.alpha = 0
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        visualEffectView.addGestureRecognizer(gesture)
    }
        
}

// MARK: - UISearchBarDelegate

extension DatabaseController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        configureSearchBar(shouldShow: false)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // hides the keyboard
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            dataCV.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filteredPortocal = portocalList.filter({ $0.city?.range(of: searchText.lowercased()) != nil })
            dataCV.reloadData()
            ProgressHUD.dismiss()
        }
    }
}

extension DatabaseController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPortocal.count : portocalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PortocalCell
        
        cell.portocal = inSearchMode ? filteredPortocal[indexPath.row] : portocalList[indexPath.row]
        cell.delegate = self
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let port = inSearchMode ? filteredPortocal[indexPath.row] : portocalList[indexPath.row]
        
        showPortocalInfoController(withPortocal: port)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if pPageID < Int(portocalData.count / 8) {
            ProgressHUD.show()
            self.loadPortocalData(pageId: self.pPageID+1)
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        ProgressHUD.dismiss()
//    }
}

extension DatabaseController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 2
        return CGSize(width: width, height: width)
        
    }
}

extension DatabaseController: PortocalCelldelegate {
    func presentInfoView(withPortocal portocal: Portocal) {
        configureSearchBar(shouldShow: false)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        view.addSubview(infoView)
        infoView.configureViewComponents()
        infoView.delegate = self
        infoView.portocal = portocal
        infoView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 64, height: 350)
        infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -44).isActive = true
        
        infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        infoView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
            self.infoView.alpha = 1
            self.infoView.transform = .identity
        }
        
    }
}

extension DatabaseController: InfoViewDelegate {
    
    func dismissInfoView(withPortocal portocal: Portocal?) {
        
        dismissInfoView(portocal: portocal)
        
    }
}


