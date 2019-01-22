//
//  CoreDataManager.swift
//  Project
//
//  Created by Zeus on 13.01.2019.
//  Copyright © 2019 Zeus. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager
{
    private let modelName = "MyModel"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        let background_context = persistentContainer.newBackgroundContext()
        background_context.automaticallyMergesChangesFromParent = true
        return background_context
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Universities> = {
        let request: NSFetchRequest<Universities> = Universities.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:"pkey", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: self.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        return frc
    }()
    
    init(fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate)
    {
        self.fetchedResultsController.delegate = fetchedResultsControllerDelegate
    }
    
    func addItem(/*objId: String,*/key: Int, title: String, subtitle: String, imgurl: String, detail: String)
    {
        let info = Universities(context: self.context)
        //info.objectId = objId
		info.pkey = Int32(key)
        info.title = title
        info.subtitle = subtitle
        info.imgurl = imgurl
        info.detail = detail
    }
	
	/*
	func addItem(university: Universities)
	{
	  let info = Universities(context: self.context)
	  info.objectId = university.objectId
	  info.pkey = university.pkey
      info.title = university.title
      info.subtitle = university.subtitle
      info.imgurl = university.imgurl
      info.detail = university.detail
	}
	*/
    
    func updateItem(item: Universities, new_title: String, new_subtitle: String, new_imgurl: String, new_detail: String)
    {
        item.title = new_title
        item.subtitle = new_subtitle
        item.imgurl = new_imgurl
        item.detail = new_detail
    }
    
    func loadData()
    {
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            print(error)
        }
    }
    
    public func getObject(index: Int) -> Universities
    {
        let indexPath = IndexPath(row: index, section: 0)
        return self.fetchedResultsController.object(at: indexPath)
    }
    
    public func getCountOfObjects(section: Int) -> Int
    {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
	
	/*
	 
	*/
    
    private func mergeChangesFromServer(serverList: [TableStructure])
    {
        var serverList = serverList
        serverList.sort(by: {$0.pkey < $1.pkey})
        if let clientList = fetchedResultsController.fetchedObjects
        {
           /* var indexServer = 0
            var indexClient = 0
            while indexServer < serverList.count || indexClient < clientList.count
            {
                if indexServer >= serverList.count
                {
                    self.context.delete(clientList[indexClient])
                    indexClient = indexClient + 1
                    continue
                }
                if indexClient >= clientList.count
                {
                    self.addItem(key: serverList[indexServer].pkey, title: serverList[indexServer].title, subtitle: serverList[indexServer].subtitle, imgurl: serverList[indexServer].image, detail: serverList[indexServer].detail)
                    indexServer = indexServer + 1
                    continue
                }
                let serverKey = serverList[indexServer].pkey
                let clientKey = clientList[indexClient].pkey
                if clientKey < serverKey
                {
                    self.context.delete(clientList[indexClient])
                    indexClient = indexClient + 1
                    continue
                }
                if clientKey == serverKey
                {
                    self.updateItem(item: clientList[indexClient], new_title: serverList[indexServer].title, new_subtitle: serverList[indexServer].subtitle, new_imgurl: serverList[indexServer].image, new_detail: serverList[indexServer].detail)
                    indexClient = indexClient + 1
                    indexServer = indexServer + 1
                    continue
                }
                if clientKey > serverKey
                {
                    self.addItem(key: serverList[indexServer].pkey, title: serverList[indexServer].title, subtitle: serverList[indexServer].subtitle, imgurl: serverList[indexServer].image, detail: serverList[indexServer].detail)
                    indexServer = indexServer + 1
                }
            }*/
			/*********************************************************************************************************************************/
			/*
			  var serverKeySet: Set<String>()
			  var clientKeySet: Set<String>()
			  for i in 0...serverList.count-1
			  {
			    serverKeySet.insert(serverList[i].objectId)
			  }
			  for i in 0...clientList.count-1
			  {
			    clientKeySet.insert(clientList[i].objectId)
			  }
			  let addKeySet = serverKeySet.subtracting(clientKeySet)
			  let deleteKeySet = clientKeySet.subtracting(serverKeySet)
			  let updateKeySet = serverKeySet.intersection(clientKeySet)
			  for i in 0...clientList.count-1
			  {
			    if deleteKeySet.contains(clientList[i].objectId)
				 {
				   self.context.delete(clientList[i])
				 }
			  }
			  for i in 0...serverList.count-1
			  {
			    if addKeySet.contains(serverList[i].objectId)
				{
				  self.addItem(serverList[i].convertToUniversity())
				}
			  }
			  
			*/
			/*********************************************************************************************************************************/
			/*
			  var serverSet: Set<Universities>()
			  var clientSet: Set<Universities>()
			  for i in 0...serverList.count-1
			  {
			    serverSet.insert(serverList[i].convertToUniversity())
			  }
			  for i in 0...clientList.count-1
			  {
			    clientSet.insert(clientList[i])
			  }
			  let addSet = serverKey.subtracting(clientSet)
			  let deleteSet = clientKey.subtracting(serverSet)
			  let updateSet = serverKey.intersection(clientSet)
			  for item in addSet 
			  {
			    self.addItem(university: item)
			  }
			  for item in deleteSet
			  {
			    self.context.delete(item)
			  }
			  for item in updateSet
			  {
			     //self.updateItem(item: clientList[indexClient], new_title: serverList[indexServer].title, new_subtitle: serverList[indexServer].subtitle, new_imgurl: serverList[indexServer].image, new_detail: serverList[indexServer].detail)
			  }
			*/
            self.saveChangesInContext()
        }
    }
    
    func synchronizateData(serverList: [TableStructure])
    {
            self.mergeChangesFromServer(serverList: serverList)
    }
    
    func saveChangesInContext()
    {
        if context.hasChanges {
            do {
                try context.save()
            }
            catch
            {
                let nserror = error as NSError
                fatalError("NSError!")
            }
        }
    }
    
}
