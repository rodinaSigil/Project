//
//  ViewController.swift
//  Project
//
//  Created by Zeus on 29.11.2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

import UIKit

protocol TableInfoManager
{
    var table_info : [TableStructure]{get}
 
    func ReadData(source: String?)
}

class PlistInfoManager : TableInfoManager
{
    var table_info: [TableStructure] = []
    
    init()
    {
        table_info = []
    }
    
    func ReadData(source: String?) {
        if  let null_str = source {
            table_info = []
            let array_of_items = NSArray(contentsOfFile: source!) as! [[String:String]]
            for items in array_of_items
            {
                table_info.append(TableStructure(info: items))
            }
        }
    }
    
    
}

// MARK: - ViewController Initialization Part

class ViewController: UIViewController {
    
    // MARK: - ViewController Properties
    var table: UITableView = UITableView()
    let pathtolist = Bundle.main.path(forResource: "Empty", ofType: "plist")
    var InfoManager: TableInfoManager?
    let cell_id = "Cell"
    
    
    
    // MARK: - ViewController Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
    }
    
    // MARK: - TableView Creating
    func createTable()
    {
        InfoManager = PlistInfoManager()
        InfoManager?.ReadData(source: pathtolist)
        self.table = UITableView(frame: view.bounds, style: .plain)
        self.table.rowHeight = UITableView.automaticDimension
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: cell_id)
        self.table.delegate = self
        self.table.dataSource = self
        view.addSubview(self.table)
        
    }

}

// MARK: - ViewController DataSource Part
extension ViewController : UITableViewDataSource
{
    
    // MARK: - DataSource Realization
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InfoManager!.table_info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = table.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
        cell.textLabel?.text = InfoManager!.table_info[indexPath.row].title
        cell.detailTextLabel?.text = InfoManager!.table_info[indexPath.row].subtitle
        cell.imageView?.image = UIImage(named: InfoManager!.table_info[indexPath.row].image)
        return cell
    }

}

// MARK: - ViewController Delegate Part
extension ViewController: UITableViewDelegate
{
    // MARK: - Delegate Realization
}
