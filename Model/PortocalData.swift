//
//  PortocalData.swift
//  Portocal
//
//  Created by Eric on 2019/10/18.
//  Copyright © 2019 Watashi NNWU Ltd. All rights reserved.
//

import Foundation

class PortocalData {
    var id: Int
    var dic: [String: AnyObject]
    
    init(idx: Int, dictionary: [String: AnyObject]) {
        self.id = idx
        self.dic = dictionary
    }
}
