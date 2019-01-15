//
//  ImageDownloader.swift
//  Project
//
//  Created by Zeus on 17.12.2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader
{
    weak var tsk:  URLSessionTask? = nil
    var tmp_image: UIImage? = nil
    
    func startDownload(url: String, block: @escaping() -> (Void))
    {
        
        let imageurl = URL(string: url)
        tsk = URLSession.shared.dataTask(with: imageurl!)
        {
            (data,response,error) -> Void in
            guard error == nil else {return}
            if let data = data
            {
                self.tmp_image = UIImage(data: data)
                DispatchQueue.main.async {
                    block()
                }
            }
        }
        tsk!.resume()
    }
    
    func stopDownload()
    {
        tsk?.cancel()
        tsk = nil
    }
    
}
