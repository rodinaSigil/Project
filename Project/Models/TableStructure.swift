//
//  TableStructure.swift
//  Project
//
//  Created by Zeus on 03.12.2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

import Foundation

struct TableStructure {
    var title: String = ""
    var subtitle: String = ""
    var image: String = ""
    
    init (info: [String:AnyObject])
    {
        self.title = info["title"]! as! String
        self.subtitle = info["subtitle"]! as! String
        self.image = info["image"]! as! String
    }
}
