enum FeedStatement
{
  case notImplement, inProcess, isImplement, isFailed
}

class DataCashItem
{
  var state: FeedStatement
  var data: NSData?
  
  init()
  {
    state = .notImplement
	data = nil
  }
  
}

class ResourceManager
{
   var requirementsTable: [CustomTableViewCell : String] = [] 
   var dataCash : [String : DataCashItem] = [] 
   
   init()
   {
     requirementsTable = []
	 dataCash = []
   } 
   
   func fetchImage(sender: CustomTableViewCell)
   {
      let url = requirementsTable[sender]
	  guard let dataCashItem = dataCash[url] else { dataCash.updateValue(url, DataCashItem()) }
	  switch (dataCashItem.state)
	  {
	     case .notImplement:
		  let imageurl = URL(string: url)
          let tsk = URLSession.shared.dataTask(with: imageurl!)
          {
               (data,response,error) -> Void in
			   dataCashItem.state = .inProcess
               guard error == nil else { 
			      dataCashItem.state = .isFailed
				  fetchImage(sender: sender)
			    }
               if let data = data
               {
                   DispatchQueue.main.async {
                       dataCashItem.data = data
					   dataCashItem.state = .isImplement
					   fetchImage(sender: sender)
                   }
               }
          }
		  tsk.resume()
		 case .inProcess:
		  return
		 case .isImplement
		  sender.imageCustom!.image = UIImage(data: dataCashItem.data)
		 case .isFailed:
		  // sender'у присваиваем картинку-null
	  }
   }
   
   func feedImageView(sender: CustomTableViewCell, url: String)
   {
      requirementsTable.updateValue(url, forKey: sender)
      fetchImage(sender: sender) 	  
   }
   
}