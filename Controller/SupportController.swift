//
//  SettingsController.swift
//  Portocal
//
//  Created by Stamate Iulian Stancu on 29/09/2019.
//  Copyright © 2019 Watashi NNWU Ltd. All rights reserved.
//

import UIKit
import MessageUI
import WebKit

class SupportController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    let supportLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.text = "©2019 Watashi NNWU Ltd, Portocal v1.0. Long press tip card in category view for location details. For anything app related tap the Support button on the top right corner to contact us. Alternatively, if your device is not configured to send emails, you can forward your enquiry to support@travelportocal.com using your preferred email provider. For Terms of Service and Privacy Policy click below."
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.center.x = self.view.center.x
        button.center.y = self.view.center.y
        button.backgroundColor = .red
        button.setTitle("Visit Support Website", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        self.view.addSubview(button)
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc func buttonAction(sender: UIButton!) {
        if let url = URL(string: "https://www.support.travelportocal.com") {
            UIApplication.shared.open(url)
        }
    }
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    @objc func configureRightBarButton() {
        let controller = SupportController()
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    
    // MARK: - Helper Functions
    @objc func showMailComposer() {
        
        guard MFMailComposeViewController.canSendMail() else {
            // Show alert informing the user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["support@travelportocal.com"])
        composer.setSubject("")
        composer.setMessageBody("", isHTML: false)
        
        present(composer, animated: true, completion: nil)
    }
    
    func configureUI() {
        view.backgroundColor = .skyBlue()
        view.contentMode = UIView.ContentMode.scaleAspectFill
        navigationController?.navigationBar.barTintColor = .darkOrange()
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Support"
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "white-down-arrow-png-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "message-icon-white-png-5").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showMailComposer))
        
        view.addSubview(supportLabel)
        supportLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 2, paddingLeft: 16, paddingBottom: 180, paddingRight: 16, width: 50, height: 50)
        supportLabel.textAlignment = NSTextAlignment.center
    }
}

extension SupportController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            //Show error alert
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
            
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        @unknown default:
            fatalError()
        }
        
        controller.dismiss(animated: true)
    }
}
