//
//  ViewController.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 27.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var contactListIds = [Int]()
    var contactListNames = [String]()
    var contactListNumbers = [Int]()
    @IBOutlet var dataContainer: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataContainer.delegate = self
        dataContainer.dataSource = self
        dataContainer.addSubview(self.refreshControl)
        
//        searchBar.sizeToFit()
//        searchBar.placeholder = "Search"
//        navigationItem.titleView = searchBar
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.loadData), name: NSNotification.Name(rawValue: "addedNewNumber"), object: nil)
    }
 
    @objc func loadData() {
        
        //Clean all arrays
        contactListIds.removeAll(keepingCapacity: false)
        contactListNumbers.removeAll(keepingCapacity: false)
        contactListNames.removeAll(keepingCapacity: false)
        
        //Fetch all rows and append them to arrays
        let allData = DatabaseUtil.sharedInstance.fetchAll()
        for row in allData {
            do {
                contactListNumbers.append(Int(try row.get(DatabaseUtil.sharedInstance.unitNumber)))
                contactListNames.append(try row.get(DatabaseUtil.sharedInstance.unitName))
                contactListIds.append(Int(try row.get(DatabaseUtil.sharedInstance.id)))
            }catch {
                print(error.localizedDescription)
            }
        }
        
        dataContainer.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListNumbers.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contactListNames.remove(at: indexPath.row)
            contactListNumbers.remove(at: indexPath.row)
            DatabaseUtil.sharedInstance.deleteById(entityId: Int64(contactListIds[indexPath.row]))
            contactListIds.remove(at: indexPath.row)
            dataContainer.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singleCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        singleCell.unitName.text = contactListNames[indexPath.row]
        singleCell.unitNumber = contactListNumbers[indexPath.row]
        return singleCell
    }
    
    
    //Refresh data table
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadData()
        refreshControl.endRefreshing()
    }
    
}

