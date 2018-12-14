//
//  PlistInfoManager.swift
//  Project
//
//  Created by Zeus on 08.12.2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

import Foundation

class PlistInfoManager : TableInfoManager
{
    var table_info: [TableStructure] = []
    
    init()
    {
        table_info = []
    }
    
    func readData(source: String?, block:@escaping () -> (Void)) {
        if  let source = source {
            table_info = []
            let array_of_items = NSArray(contentsOfFile: source) as? [[String:String]]
            for items in array_of_items ?? []
            {
                table_info.append(TableStructure(info: items))
            }
        }
    }
}
