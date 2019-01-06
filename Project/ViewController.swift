//
//  ViewController.swift
//  Project
//
//  Created by Zeus on 29.11.2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

import UIKit
import CoreData

// MARK: - ViewController Initialization Part

class ViewController: UIViewController {
    
    // MARK: - ViewController Properties
    @IBOutlet var table: UITableView!
    let source_path = "https://backendlessappcontent.com/5320F2D6-E3A1-93AE-FF2C-60A9F73F9500/console/korjvxnfwmlouxyxnnatgqyftruvysqhryxw/files/view/source.json"
    var InfoManager: TableInfoManager! = URLInfoManager()
    let cell_id = "Cell"

    var coreDataManager: CoreDataManager!
    
    // MARK: - ViewController Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coreDataManager = CoreDataManager(fetchedResultsControllerDelegate: self)
        createTable()
        self.coreDataManager.loadData()
    }
    
    // MARK: - TableView Creating
    func createTable()
    {
        self.table.rowHeight = UITableView.automaticDimension
        self.table.register(CustomTableViewCell.self, forCellReuseIdentifier: cell_id)
        self.table.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: cell_id)
        self.table.dataSource = self
//        InfoManager!.readData(source: source_path, block: { self.table.reloadData() } )
    }
}

// MARK: - ViewController DataSource Part
extension ViewController : UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager.getCountOfObjects(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = table.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! CustomTableViewCell
        let item = coreDataManager.getObject(index: indexPath.row)
        cell.titleLabel?.text = item.title
        cell.subtitleLabel?.text = item.subtitle
        cell.setImage(URL: item.imgurl ?? "")
        return cell
    }
    
    @IBAction func refreshData(sender: UIButton)
    {
        self.coreDataManager.synchronizateData(url: source_path)
        //  self.table.reloadData()
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            table.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            table.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        }
    }
    
    private func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        let indexPath = indexPath as IndexPath?
        let newIndexPath = newIndexPath as IndexPath?
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                table.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                guard let cell = table.cellForRow(at: indexPath) as? CustomTableViewCell else { break }
                let item = coreDataManager.getObject(index: indexPath.row)
                cell.titleLabel?.text = item.title
                cell.subtitleLabel?.text = item.subtitle
                cell.setImage(URL: item.imgurl ?? "")
            }
        case .move:
            if let indexPath = indexPath {
                table.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                table.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                table.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.endUpdates()
    }
}

class CoreDataManager
{
    private let modelName = "CellModel"
    
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
    
    lazy var fetchedResultsController: NSFetchedResultsController<TableCell> = {
        let request: NSFetchRequest<TableCell> = TableCell.fetchRequest()
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
    
    private func addItem(key: Int, title: String, subtitle: String, imgurl: String)
    {
        //let info = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: self.context) as! TableCell
        let info = TableCell(context: self.context)
        info.pkey = Int32(key)
        info.title = title
        info.subtitle = subtitle
        info.imgurl = imgurl
    }
    
    private func updateItem(item: TableCell, new_title: String, new_subtitle: String, new_imgurl: String)
    {
        item.title = new_title
        item.subtitle = new_subtitle
        item.imgurl = new_imgurl
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
    
    public func getObject(index: Int) -> TableCell
    {
        let indexPath = IndexPath(row: index, section: 0)
        return self.fetchedResultsController.object(at: indexPath)
    }
    
    public func getCountOfObjects(section: Int) -> Int
    {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    private func mergeChangesFromServer(serverList: [TableStructure])
    {
        // ÔÓÎÛ˜‡ÂÏ ‰‡ÌÌ˚Â ËÁ fetchedResultsController
        // loadData()
        var serverList = serverList
        serverList.sort(by: {$0.pkey < $1.pkey})
        
        if let clientList = fetchedResultsController.fetchedObjects
        {
            // ‚ÓÁÏÓÊÌÓ ÌÛÊÌ‡ ‰ÓÔ. ÒÓÚËÓ‚Í‡ ÔÓÒÎÂ ‰Ó·‡‚ÎÂÌËˇ, Ú.Í. ‰Ó·‡‚ÎÂÌËÂ ‚ˇ‰ ÎË ·Û‰ÂÚ ÔÓËÒıÓ‰ËÚ¸ ÛÔÓˇ‰Ó˜ÂÌÌÓ?
            var indexServer = 0
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
                    self.addItem(key: serverList[indexServer].pkey, title: serverList[indexServer].title, subtitle: serverList[indexServer].subtitle, imgurl: serverList[indexServer].image)
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
                    self.updateItem(item: clientList[indexClient], new_title: serverList[indexServer].title, new_subtitle: serverList[indexServer].subtitle, new_imgurl: serverList[indexServer].image)
                    indexClient = indexClient + 1
                    indexServer = indexServer + 1
                    continue
                }
                if clientKey > serverKey
                {
                    self.addItem(key: serverList[indexServer].pkey, title: serverList[indexServer].title, subtitle: serverList[indexServer].subtitle, imgurl: serverList[indexServer].image)
                    indexServer = indexServer + 1
                }
            }
            self.saveChangesInContext(saving_context: self.context)
        }
    }
    
    func synchronizateData(url: String?)
    {
        if let url = url
        {
            let urlInfoManager = URLInfoManager()
            urlInfoManager.readData(source: url) { [weak self] in
                self?.mergeChangesFromServer(serverList: urlInfoManager.table_info)
            }
        }
    }
    
    func saveChangesInContext(saving_context: NSManagedObjectContext)
    {
        if saving_context.hasChanges {
            do {
                try saving_context.save()
            }
            catch
            {
                let nserror = error as NSError
                fatalError("NSError!")
            }
        }
    }
    
}
