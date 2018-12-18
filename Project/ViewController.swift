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

    
    
    
    // MARK: - ViewController Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
    }
    
    // MARK: - TableView Creating
    func createTable()
    {
        self.table.rowHeight = UITableView.automaticDimension
        self.table.register(CustomTableViewCell.self, forCellReuseIdentifier: cell_id)
        self.table.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: cell_id)
        self.table.delegate = self
        self.table.dataSource = self
        InfoManager!.readData(source: source_path, block: { self.table.reloadData() } )
    }

}

// MARK: - ViewController DataSource Part
extension ViewController : UITableViewDataSource
{
    
    // MARK: - DataSource Realization
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InfoManager!.table_info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = table.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! CustomTableViewCell
        let item = InfoManager!.table_info[indexPath.row]
        cell.titleLabel?.text = item.title
        cell.subtitleLabel?.text = item.subtitle
        cell.setImage(URL: item.image)
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
        self.table.reloadData()
    }
}
