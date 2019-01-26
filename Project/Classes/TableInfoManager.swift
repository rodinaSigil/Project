//
//  TableInfoManager.swift
//  Project
//
//  Created by Zeus on 08.12.2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

import Foundation

protocol TableInfoManager
{
    var table_info : [TableStructure]{get}
    
    func readData(source: String?, block:@escaping () -> (Void))
}
