//
//  URLInfoManager.swift
//  Project
//
//  Created by Zeus on 08.12.2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

import Foundation
import UIKit

class URLInfoManager : TableInfoManager
{
    var table_info: [TableStructure] = []

    init()
    {
        table_info = []
    }
    
//    func sortByPrimaryKey()
//    {
//        table_info.sort(by: {$0.pkey > $1.pkey})
////        table_info.sortInPlace{ $0.pkey > $1.pkey } // !!! ÔÓ Ë‰ÂÂ ˝ÚÓ ‰ÓÎÊÌÓ ·˚Ú¸ ÔÓ ‚ÓÁ‡ÒÚ‡ÌË˛
//    }
    
    func readData(source: String?, block:@escaping () -> (Void)) {
        if let source = source
        {
            table_info = []
            let url = URL(string: source)
            let task = URLSession.shared.dataTask(with: url!) {
                (data,response,error) -> Void in
                guard error == nil else { return }
                if let data = data
                {
                    do
                    {
                        let json_array = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String:AnyObject]]
                        if let json_array = json_array
                        {
                            for index in 0...json_array.count-1
                            {
                                self.table_info.append(TableStructure(info: json_array[index]))
                            }
                        }
                        DispatchQueue.main.async {
                            block()
                        }
                    }
                    catch {
                        return
                    }
                }
            }.resume()
        }
    }
}
    
    

