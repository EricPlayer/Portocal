//
//  ContainerController.swift
//  Portocal
//
//  Created by Stamate Iulian Stancu on 29/09/2019.
//  Copyright © 2019 Watashi NNWU Ltd. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    var menuController: MenuController!
    var centerController: UIViewController!
    var isExpanded = false
    var tap = UITapGestureRecognizer()
    
    //MARK: - Properties
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Handlers
    
    func configureHomeController() {
        let homeController = HomeController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        if menuController == nil {
            // add our menu controller here
            
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if isExpanded {
            animatePanel(shouldExpand: false, menuOption: nil)
            centerController.view.removeGestureRecognizer(tap)
        }
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
        
        if shouldExpand {
            //show menu
            isExpanded = true
            tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            centerController.view.addGestureRecognizer(tap)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 150
            }, completion: nil)
        } else {
            //hide menu

            isExpanded = false
            centerController.view.removeGestureRecognizer(tap)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .About:
            let controller = AboutController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .Support:
            let controller = SupportController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .Database:
            let controller = DatabaseController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .PrivacyPolicy:
            if let url = URL(string: "https://www.travelportocal.com/privacy-policy") {
                UIApplication.shared.open(url)
            }
        }
    }
    
}
extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
}
