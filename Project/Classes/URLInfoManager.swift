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
    
    private func bodyForFileSendRequest(boundary: String, fileName: String, data: Data) -> NSMutableData
    {
        let fullData = NSMutableData()
        
        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.append(lineTwo.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 4
        fullData.append(data)
        
        // 5
        let lineFive = "\r\n"
        fullData.append(lineFive.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        return fullData
        
    }
    
    func sendImageToServer(name: String, urlPath: String, jpgdata: Data?, sender: Universities)
    {
        if let jpgdata = jpgdata
        {
            // urlpath += /filename?overwrite=true
            let urlNewPath = urlPath + "/\(name)?overwrite=true"
            let boundary = "boundaryForImage"+name
            var url: URL = URL(string: urlNewPath)!
            var request: URLRequest = URLRequest(url: url)
            request.httpMethod = "POST"
            let data = bodyForFileSendRequest(boundary: boundary, fileName: name, data: jpgdata)
            request.httpBody = data as Data
            request.setValue("multipart/form-data; boundary="+boundary, forHTTPHeaderField: "Content-type")
            request.setValue(String(data.length), forHTTPHeaderField: "Content-Length")
            let tsk = URLSession.shared.dataTask(with: request)
            {
                (data,response,error) -> Void in
                guard error == nil else { return }
                if response != nil
                {
                    let httpResponse = response as! HTTPURLResponse
                    if  httpResponse.statusCode == 200
                    {
                        let stringURL = urlPath + "/\(name)"
                        DispatchQueue.main.async {
                            sender.imgurl = stringURL
                        }
                    }
                }
            }
            tsk.resume()
        }
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
