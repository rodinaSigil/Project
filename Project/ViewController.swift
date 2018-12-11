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
    @IBOutlet var table: UITableView! /*= UITableView()*/
    let pathtolist = "https://backendlessappcontent.com/EE09D4F9-8B6E-F7DC-FFBD-56FE80B4A300/console/hafkgwjydgkfbbggwzqmvncssngzccvtmxwx/files/view/source.json"
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
        InfoManager = URLInfoManager()
        InfoManager?.readData(source: pathtolist)
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
        return InfoManager?.table_info.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = table.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
        cell.textLabel?.text = InfoManager?.table_info[indexPath.row].title
        cell.detailTextLabel?.text = InfoManager?.table_info[indexPath.row].subtitle
        //cell.imageView?.image = UIImage(named: InfoManager?.table_info[indexPath.row].image ?? "")
        /*let image = InfoManager?.table_info[indexPath.row].image
        if image != nil
        {
           
        }*/
        cell.imageView?.image = (InfoManager as! URLInfoManager).GetImage(ItemIndex: indexPath.row)
        return cell
    }
}

// MARK: - ViewController Delegate Part
extension ViewController: UITableViewDelegate
{
    // MARK: - Delegate Realization
}

// MARK: - ViewController Actions
extension ViewController
{
    @IBAction func refreshData(sender: UIButton)
    {
        InfoManager?.readData(source: pathtolist)
       // self.table.dataSource = nil
      //  self.table.dataSource = self
        self.table.reloadData()
    }
}
