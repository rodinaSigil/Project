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
    let source_path = "https://backendlessappcontent.com/1635C9DF-95AF-D692-FF8F-6FB81E271200/console/gbjgkiqtxlfyrutkvgtpfdcaxceodegdgtmz/files/view/source.json"
    var InfoManager: TableInfoManager! = URLInfoManager()
    let cell_id = "Cell"
    var coreDataManager: CoreDataManager!
 //   var indexRow: Int = -1
 //   var pictureRow: UIImage? = nil
	var modForModifyVC: ModifyMod? = nil
	
    // MARK: - ViewController Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coreDataManager = CoreDataManager(fetchedResultsControllerDelegate: self)
		let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
		self.navigationItem.leftBarButtonItem = addBtn
		let synchronizeBtn = UIBarButtonItem(title: "Synchronize", style: .done, target: self, action: #selector(refreshData))
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
        cell.setImage(URL: item.imgurl ?? "")
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
        self.performSegue(withIdentifier: "ToModify", sender: (cell, indexPath.row))
    }
    
}

// MARK: - ViewController Actions
extension ViewController
{
    
    func refreshData()
    {
	     if source_path != ""
		 {
		    let urlInfoManager = URLInfoManager() // !!!!!!!
            urlInfoManager.readData(source: url) { 
                coreDataManager.synchronizateData(data: urlInfoManager.table_info)
            }
		 }
    }
    
    func addButtonTapped()
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
			  destinationController.university = coreDataManager.getObject(index: ((sender as! (CustomTableViewCell, Int)).1))
              destinationController.picture = ((sender as! (CustomTableViewCell, Int)).0).imageCustom!.image
              destinationController.coreDataManager = self.coreDataManager
			}
			destinationController.mode = modForModifyVC
	      }
        }
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.endUpdates()
    }
}


