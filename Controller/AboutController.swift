//
//  SettingsController.swift
//  Portocal
//
//  Created by Stamate Iulian Stancu on 29/09/2019.
//  Copyright © 2019 Watashi NNWU Ltd. All rights reserved.
//

import UIKit

class AboutController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    let supportLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "About"
        label.textColor = .black
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supportLabel.isEditable = false
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .skyBlue()
        view.contentMode = UIView.ContentMode.scaleAspectFill
        navigationController?.navigationBar.barTintColor = .darkOrange()
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "About"
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "white-down-arrow-png-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        view.addSubview(supportLabel)
        supportLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 50, height: 50)
    }
}
