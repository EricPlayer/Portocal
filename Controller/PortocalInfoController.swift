//
//  PortocalInfoController.swift
//  Portocal
//
//  Created by Stamate Iulian Stancu on 12/10/2019.
//  Copyright © 2019 Watashi NNWU Ltd. All rights reserved.
//

import UIKit

class PortocalInfoController: UIViewController {
    
    // MARK: - Properties
    var scrollView: UIScrollView!
    
    var portocal: Portocal? {
        didSet {
            navigationItem.title = portocal?.city?.capitalized
            imageView.image = portocal?.image
            infoLabel.text = portocal?.description
            titleLabel.text = portocal?.tip
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        //iv.layer.cornerRadius = 10
        return iv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Futura", size:13.0)
        label.numberOfLines = 0
        label.textColor = .black
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        //label.layer.cornerRadius = 10
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textColor = .black
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        //label.layer.cornerRadius = 10
        return label
    }()
    
    let infoView: InfoView = {
        let view = InfoView()
        view.configureViewComponents()
        return view
    }()
    
    // MARk: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 300, height: 300)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
        titleLabel.textAlignment = NSTextAlignment.center
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, width: 0, height: 0)
        infoLabel.textAlignment = NSTextAlignment.center
    }
}

