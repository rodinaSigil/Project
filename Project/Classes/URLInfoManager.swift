//
//  URLInfoManager.swift
//  Project
//
//  Created by Zeus on 08.12.2018.
//  Copyright © 2018 Zeus. All rights reserved.
//
import Foundation

class URLInfoManager : TableInfoManager
{
    var table_info: [TableStructure] = []
    
    init()
    {
        table_info = []
    }
    
    func sendImageToServer(name: String, urlPath: String, jpgdata: Data?, sender: Universities)
    {
        if let jpgdata = jpgdata
        {
        let url = URL(string: urlPath+"/\(name)"+"?overwrite=true")!
        var request = URLRequest(url: url)
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jpgdata
        var urlImage = ""
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            if let httpResponse = response as? HTTPURLResponse
            {
                if let urlImg = httpResponse.allHeaderFields["fileURL"] as? String
                {
                    urlImage = urlImg
                }
            }
            DispatchQueue.main.async {
                sender.imgurl = urlImage
            }
        }
        task.resume()
        }
    }
	
	func synchronizateData(data: [Universities])
	{
	  
	}

    
    func readData(source: String?, block:@escaping () -> (Void)) {
        if let source = source
        {
            table_info = []
            let url = URL(string: source)
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request)
            {
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
                
            }
            
        }
    }
    
}
