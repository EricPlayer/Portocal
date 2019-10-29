//
//  HomeController.swift
//  Portocal
//
//  Created by Stamate Iulian Stancu on 29/09/2019.
//  Copyright © 2019 Watashi NNWU Ltd. All rights reserved.
//

import UIKit
import WebKit

struct CustomData {
    var url: String
    var backgroundImage: UIImage
}

class HomeController: UIViewController {
    
    var delegate: HomeControllerDelegate?
    
    //MARK: - Properties
    
    let categoriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.textColor = .darkOrange()
        label.backgroundColor = .darkPurple()
        label.font = UIFont(name: "Arial-BoldMT", size: 32)
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    
    fileprivate let data = [
        CustomData(url: "http://www.portocal.com", backgroundImage: UIImage(imageLiteralResourceName: "Restaurants")),
        CustomData(url: "http://www.portocal.com", backgroundImage: UIImage(imageLiteralResourceName: "OutstandingLocations")),
        CustomData(url: "http://www.portocal.com", backgroundImage: UIImage(imageLiteralResourceName: "Beaches")),
        CustomData(url: "http://www.portocal.com", backgroundImage: UIImage(imageLiteralResourceName: "Activities"))
    ]
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .skyBlue()
        configureNavigationBar()
        configureCollectionView()
    }
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func showDataCV() {
        let selVC = DatabaseController()
        selVC.inSearchMode = true
        selVC.navTitle = "Search by City"
        selVC.isCitySearch = true
        present(UINavigationController(rootViewController: selVC), animated: true, completion: nil)
    }
    
    
    //MARK: - Handlers
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkOrange()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Portocal"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "whooos-reading-pngs-menus-200_200").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showDataCV))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func configureCollectionView() {
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .skyBlue()
        collectionView.delegate = self 
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        
        view.addSubview(categoriesLabel)
        categoriesLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: collectionView.topAnchor, right: view.rightAnchor, paddingTop: 48, paddingLeft: 48, paddingBottom: 48, paddingRight: 48, width: 50, height: 50)
        categoriesLabel.textAlignment = NSTextAlignment.center
        categoriesLabel.layer.borderWidth = 4
        categoriesLabel.layer.borderColor = UIColor.white.cgColor
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.data = self.data[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selVC = DatabaseController()
        switch indexPath.row {
        case 0:
            selVC.searchKey = "restaurants"
            break

        case 1:
            selVC.searchKey = "outstanding locations"
            break

        case 2:
            selVC.searchKey = "beaches"
            break

        case 3:
            selVC.searchKey = "activities"
            break
            
        default:
            selVC.searchKey = ""
        }
        selVC.isCategorySearch = true
        selVC.navTitle = selVC.searchKey
        present(UINavigationController(rootViewController: selVC), animated: true, completion: nil)
    }
}
