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
    let source_path = "https://develop.backendless.com/1635C9DF-95AF-D692-FF8F-6FB81E271200/FDE223AC-8187-63FC-FF2C-031A610D0900/data/University"
    var InfoManager: TableInfoManager! = URLInfoManager()
    let cell_id = "Cell"
    var coreDataManager: CoreDataManager!
	var modForModifyVC: ModifyMod? = nil
    let resDowmnloader: ResourceDownloader = ResourceDownloader()
	
    // MARK: - ViewController Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coreDataManager = CoreDataManager(fetchedResultsControllerDelegate: self)
		let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
		self.navigationItem.leftBarButtonItem = addBtn
        let synchronizeBTN = UIBarButtonItem(title: "S", style: .done, target: self, action: #selector(refreshData))
        self.navigationItem.rightBarButtonItem = synchronizeBTN
        createTable()
        self.coreDataManager.loadData()
        
    }
    
    // MARK: - TableView Creating
    func createTable()
    {
        self.table.rowHeight = UITableView.automaticDimension
        self.table.register(CustomTableViewCell.self, forCellReuseIdentifier: cell_id)
        self.table.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: cell_id)
        self.table.delegate = self
        self.table.dataSource = self
       // InfoManager!.readData(source: source_path, block: { self.table.reloadData() } )
        
    }

}

// MARK: - ViewController DataSource Part
extension ViewController : UITableViewDataSource
{
    
    // MARK: - DataSource Realization
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return coreDataManager.getCountOfObjects(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = table.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! CustomTableViewCell
        let item = coreDataManager.getObject(index: indexPath.row)
        cell.titleLabel?.text = item.title
        cell.subtitleLabel?.text = item.subtitle
        
        if let url = item.imgurl {
            if let data = self.resDowmnloader.resource(forUrl: url) {
                cell.imageCustom.image = UIImage(data: data)
            } else {
                self.resDowmnloader.getResource(url: item.imgurl ?? "") { imageData in
                    if let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
                        cell.imageCustom.image = UIImage(data: imageData)
                    }
                }
            }
        }
        return cell
    }
}

// MARK: - ViewController Delegate Part
extension ViewController: UITableViewDelegate
{
    // MARK: - Delegate Realization
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
		self.modForModifyVC = ModifyMod.update
        self.performSegue(withIdentifier: "ToModify", sender: (cell,indexPath.row))
    }
    
}

// MARK: - ViewController Actions
extension ViewController
{
    
    
    @objc func refreshData()
    {
     
        var serverList: [TableStructure] = [
            TableStructure(pkey: 1, imgURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/The_University_of_California_UCLA.svg/800px-The_University_of_California_UCLA.svg.png"),
             TableStructure(pkey: 2, imgURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Inverted_Fountain%2C_UCLA.jpg/120px-Inverted_Fountain%2C_UCLA.jpg"),
              TableStructure(pkey: 3, imgURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/UCLA_hoodie.jpg/800px-UCLA_hoodie.jpg"),
              TableStructure(pkey: 4, imgURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Royce_Hall_post_rain.jpg/800px-Royce_Hall_post_rain.jpg"),
              TableStructure(pkey: 5, imgURL: "https://upload.wikimedia.org/wikipedia/ru/1/1c/Harvard_shield.png"),
               TableStructure(pkey: 6, imgURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/John_Harvard_statue.jpg/800px-John_Harvard_statue.jpg"),
               TableStructure(pkey: 7, imgURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Harvard_college_-_annenberg_hall.jpg/800px-Harvard_college_-_annenberg_hall.jpg"),
                TableStructure(pkey: 8, imgURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Harvard_University_Massachusetts_Hall.jpg/800px-Harvard_University_Massachusetts_Hall.jpg"),
                 TableStructure(pkey: 9, imgURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/The_University_of_California_UCLA.svg/800px-The_University_of_California_UCLA.svg.png"),
                  TableStructure(pkey: 10, imgURL: "https://upload.wikimedia.org/wikipedia/commons/4/43/Hbs-charles.jpg")
                 ]
        coreDataManager.synchronizateData(serverList: serverList)
    }
    
    @objc func addButtonTapped()
	{
	   self.modForModifyVC = ModifyMod.insert
	   self.performSegue(withIdentifier: "ToModify", sender: self)
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToModify"
        {
		  if let modForModifyVC = modForModifyVC
          {
			let destinationController = segue.destination as! ModifyViewController
			if modForModifyVC == ModifyMod.update
            {
              let pic = (((sender as! (UITableViewCell,Int)).0) as! CustomTableViewCell).imageCustom.image
              let objInd = (sender as! (UITableViewCell,Int)).1
              destinationController.university = coreDataManager.getObject(index: objInd)
              destinationController.picture = pic
			}
			destinationController.mode = modForModifyVC
            destinationController.coreDataManager = self.coreDataManager
            
            }
        }
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                table.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                table.reloadRows(at: [indexPath], with: .automatic)
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
    

    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.endUpdates()
    }
}


