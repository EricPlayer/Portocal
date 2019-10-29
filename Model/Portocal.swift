//
//  Portocal.swift
//  Portocal
//
//  Created by Stamate Iulian Stancu on 12/10/2019.
//  Copyright © 2019 Watashi NNWU Ltd. All rights reserved.
//

import UIKit

class Portocal {
    
    var area: String?
    var city: String?
    var id: Int?
    var country: String?
    var description: String?
    var imageUrl: String?
    var image: UIImage?
    var street: String?
    var category: String?
    var tip: String?
    
    var restaurants: String?
    var outstandinglocations: String?
    var beaches: String?
    var activities: String?
    
    init(id: Int, dictionary: [String: AnyObject]) {
        
        self.id = id
        
        if let area = dictionary["area"] as? String {
            self.area = area.capitalized
        }
        
        if let city = dictionary["city"] as? String {
            self.city = city
        }
        
        if let country = dictionary["country"] as? String {
            self.country = country.capitalized
        }
        
        if let description = dictionary["description"] as? String {
            self.description = description
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
            let imgUrl = URL(string: imageUrl)
            let data = try? Data(contentsOf: imgUrl!)
            if let imageData = data {
                self.image = UIImage(data: imageData)
            }
        }
        
        if let street = dictionary["street"] as? String {
            self.street = street.capitalized
        }
        
        if let category = dictionary["category"] as? String {
            self.category = category
        }
        
        if let tip = dictionary["tip"] as? String {
            self.tip = tip.capitalized
        }
        
        if let restaurants = dictionary["restaurants"] as? String {
            self.restaurants = restaurants
        }
        
        if let outstandinglocations = dictionary["outstandinglocations"] as? String {
            self.outstandinglocations = outstandinglocations.capitalized
        }
        
        if let beaches = dictionary["beaches"] as? String {
            self.beaches = beaches
        }
        
        if let activities = dictionary["activities"] as? String {
            self.activities = activities.capitalized
        }

    }
}

