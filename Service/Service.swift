//
//  Service.swift
//  Portocal
//
//  Created by Stamate Iulian Stancu on 12/10/2019.
//  Copyright © 2019 Watashi NNWU Ltd. All rights reserved.
//

import UIKit

class Service {
    
    static let shared = Service()
    
    let BASE_URL = "https://portocal-9a18.firebaseio.com/portocal.json"
    
    func fetchPortocal(completion: @escaping ([Portocal]) -> ()) {
        var portocalArray = [Portocal]()
        
        guard let url = URL(string: BASE_URL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // handle error
            
            if let error = error {
                print("Failed to fetch data with error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                guard let resultArray = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] else { return }
                
                for (key, result) in resultArray.enumerated() {
                    
                    if let dictionary = result as? [String: AnyObject] {
                        let portocal = Portocal(id: key, dictionary: dictionary)
                        guard let imageUrl = portocal.imageUrl else { return }
                        
                        self.fetchImage(withUrlString: imageUrl, completion: { (image) in
                            portocal.image = image
                            portocalArray.append(portocal)
                            
                            portocalArray.sort(by: { (port1, port2) -> Bool in
                             return port1.id! < port2.id!
                            })
                            
                            completion(portocalArray)
                        })
                    }
                }
                
            } catch let error {
                print("Failed to create json with error: ", error.localizedDescription)
            }
            
            }.resume()
        
    }
    
    private func fetchImage(withUrlString urlString: String, completion: @escaping(UIImage) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch image with error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            completion(image)
            
            }.resume()
    }
}

