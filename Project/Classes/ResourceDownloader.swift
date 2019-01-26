
/*protocol ResourceDownloaderDelegate
{
  func finishDownloadingCompletion()
  {
     
  }
}*/

import Foundation

protocol ResourcedwonloaderDelegate
{
    func resourceDownloader(_ resourceDownloader: ResourceDownloader, didEndDownloadingData data: Data)
    
}

class ResourceDownloader
{
   var resourceTable: [String: Data?] = [:]
  
   
   init(/*delegate: ResourceDownloaderDelegate*/)
   {
     //self.delegate = delegate
   }
   
   private func downloadResource(url: String, completion: @escaping (Data) -> (Void))
   {
        guard let imageurl = URL(string: url) else {return}
        let tsk = URLSession.shared.dataTask(with: imageurl) { (data,response,error) -> Void in
            if let data = data, !data.isEmpty
            {
                self.resourceTable.updateValue(data, forKey: url)
                DispatchQueue.main.async {
                    completion(data)
                }
                return
            }
            self.resourceTable.removeValue(forKey: url)
        }
        tsk.resume()
   }
   
    func getResource(url: String, completion: @escaping (Data) -> (Void)) {
        if resourceTable.keys.contains(url) {
            if let data = resourceTable[url] as? Data {
                completion(data)
            } else {
                return
            }
        } else {
            resourceTable.updateValue(nil, forKey: url)
            downloadResource(url: url, completion: completion)
        }
    }
} 
