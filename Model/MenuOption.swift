//
//  MenuOption.swift
//  Portocal
//
//  Created by Stamate Iulian Stancu on 29/09/2019.
//  Copyright © 2019 Watashi NNWU Ltd. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case About
    case Support
    case Database
    case PrivacyPolicy
    
    var description: String {
        switch self {
        case .About: return "About"
        case .Support: return "Support"
        case .Database: return "Main Feed"
        case .PrivacyPolicy: return "Privacy Policy"
        }
    }
    
    var image: UIImage {
        switch self {
        case .About: return UIImage(named: "about-us-icon.png") ?? UIImage()
        case .Support: return UIImage(named: "69114.png")  ?? UIImage()
        case .Database: return UIImage(named: "collection.png")  ?? UIImage()
        case .PrivacyPolicy: return UIImage(named: "225934200.png")  ?? UIImage()
        }
    }
    
}

