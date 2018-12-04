//
//  ViewController.swift
//  Project
//
//  Created by Zeus on 29.11.2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

import UIKit

// MARK: - ViewController Initialization Part

class ViewController: UIViewController {
    
    // MARK: - ViewController Properties
    var table: UITableView = UITableView()
    let pathtolist = Bundle.main.path(forResource: "Empty", ofType: "plist")
    var arrayofitems: [[String:String]] = []
    let cell_id = "Cell"
    var table_info : [TableStructure] = []
    
    // MARK: - ViewController Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
    }
    
    // MARK: - TableView Creating
    func createTable()
    {
        ReadData()
        self.table = UITableView(frame: view.bounds, style: .plain)
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
        return arrayofitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = table.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: cell_id)
        cell.textLabel?.text = table_info[indexPath.row].title
        cell.detailTextLabel?.text = table_info[indexPath.row].subtitle
        cell.imageView?.image = UIImage(named: table_info[indexPath.row].image)
        return cell
    }
    
    // MARK: - Data Reading for TableView
    func ReadData()
    {
        arrayofitems = NSArray(contentsOfFile: pathtolist!) as! [[String:String]]

        table_info = []
        for items in arrayofitems
        {
            table_info.append(TableStructure(info: items))
        }
    }
    
    
    
}

// MARK: - ViewController Delegate Part
extension ViewController: UITableViewDelegate
{
    // MARK: - Delegate Realization
}
