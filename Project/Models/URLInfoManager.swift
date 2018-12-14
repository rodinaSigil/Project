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
                        let json_array = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String:String]]
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
            }
        }
    }
    
    /*func readData(source: String?) {
        if let source = source
        {
             table_info = []
             let url = URL(string: source)
             if let url = url
             {
                let task = URLSession.shared.dataTask(with: url) {
                    (Data, URLResponse, Error) -> Void in
                    guard Error == nil else {return}
                    if let Data = Data
                    {
                        do
                        {
                            let json_array = try? JSONSerialization.jsonObject(with: Data, options: []) as! [[String:String]]
                            if let json_array = json_array
                            {
                                for index in 0...json_array.count-1
                                {
                                    self.table_info.append(TableStructure(info: json_array[index]))
                                    print(index)
                                }
                            }
                        }
                        catch {
                            print(Error)
                            return
                        }
                        
                    }
                }.resume()
             }
            
            
        }
    }*/

    /*public func GetImage(ItemIndex: Int) -> UIImage?
    {
        var image = UIImage()
        if ItemIndex != nil, self.table_info != nil
        {
           if ItemIndex > 0, ItemIndex < self.table_info.count - 1
           {
              let urlimage = URL(string: table_info[ItemIndex].image)
              let request = URLRequest(url: urlimage!)
            
            let task = URLSession.shared.dataTask(with: request) {
                (Data,URLResponse,Error) -> Void in
                OperationQueue.main.addOperation({() -> Void in
                    if Error == nil && Data != nil
                    {
                        image = UIImage(data: Data!) ?? UIImage()
                    }
                })
            }
            task.resume()
            return image
           }
            else
           {
              return nil
            }
        }
        else
        {
            return nil
            
        }
    }*/
    
}
    
    

