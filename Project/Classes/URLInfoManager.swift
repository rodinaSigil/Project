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
    let applicationId = "1635C9DF-95AF-D692-FF8F-6FB81E271200"
    let restApiKey = "FDE223AC-8187-63FC-FF2C-031A610D0900"
    let backendless = Backendless.sharedInstance()
    
    var max_pkey: Int {
        get {
            var max: Int! = 0
                if table_info.count != 0
                {
                    max = table_info[0].pkey
                    for index in 1...table_info.count-1
                    {
                        if max < table_info[index].pkey
                        {
                            max = table_info[index].pkey
                        }
                    }
                }
            
            return max;
        }
    }

    
    init()
    {
        table_info = []
		backendless!.initApp(applicationId, apiKey: restApiKey)
    }
    
    func uploadToServerJPGData(data: Data, withName: String) -> String
    {
        var resultURL: String = ""
        /*backendless!.file.saveFile(withName+".jpg",
                                  content: data,
                                  overwrite: true,
                                  response: {
                                    (uploadFile: BackendlessFile?) -> Void in
                                    print("File uploaded: \(String(describing: uploadFile))")
                                    resultURL = uploadFile
        },
                                  error: {
                                    (fault: Fault?) -> Void in
                                    print("Server reported an error: \(String(describing: fault?.description))")
                                    resultURL = ""
        }
        )*/
		//resultURL = "https://api.backendless.com/\(applicationId)/\(restApiKey)/files/\(withName)"
        return resultURL
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
