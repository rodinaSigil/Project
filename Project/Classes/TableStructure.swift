//
//  TableStructure.swift
//  Project
//
//  Created by Zeus on 03.12.2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

struct TableStructure {
    var pkey: Int = -1
    var title: String = ""
    var subtitle: String = ""
    var image: String = ""
    var detail: String = ""
    
    init (info: [String:AnyObject])
    {
        self.pkey = info["pkey"] as? Int ?? -1
        self.title = info["title"] as? String ?? ""
        self.subtitle = info["subtitle"] as? String ?? ""
        self.image = info["image"] as? String ?? ""
        self.detail = info["detail"] as? String ?? ""
    }
}
