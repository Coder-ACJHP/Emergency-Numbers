//
//  ViewController.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 27.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    

    var singleCell = TableViewCell()
    var contactList: [ContactNumber] = []
    @IBOutlet var dataContainer: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataContainer.delegate = self
        dataContainer.dataSource = self
        dataContainer.addSubview(self.refreshControl)
        
        searchBar.delegate = self
        
        
        //Populate table
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.loadData), name: NSNotification.Name(rawValue: "addedNewNumber"), object: nil)
    }
 
    @objc func loadData() {
        
        //Clean all arrays
        contactList.removeAll(keepingCapacity: false)
        
        //Fetch all rows and append them to arrays
        let allData = DatabaseUtil.sharedInstance.fetchAll()
        for row in allData {
            do {
                contactList.append(ContactNumber(
                    contactId: Int64(try row.get(DatabaseUtil.sharedInstance.id)),
                    contactName: String(try row.get(DatabaseUtil.sharedInstance.description)),
                    contactNumber: Int64(try row.get(DatabaseUtil.sharedInstance.phoneNumber)))
                )
            }catch {
                print(error.localizedDescription)
            }
        }
        
        dataContainer.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            DatabaseUtil.sharedInstance.deleteById(entityId: Int64(contactList[indexPath.row].id))
            contactList.remove(at: indexPath.row)
            dataContainer.reloadData()

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        singleCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        singleCell.unitName.text = contactList[indexPath.row].description
        singleCell.unitNumber = Int(contactList[indexPath.row].phoneNumber)
        return singleCell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            self.loadData()
        } else {
            
            var filtered:[ContactNumber] = []
            filtered = contactList.filter {$0.description.contains(searchText)}
            contactList = filtered
            self.dataContainer.reloadData()
            
            contactList.forEach { (contactNumber) in
                contactNumber.toString()
            }
        }
    }
    
    
    //Refresh data table
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.init(red: 55.0/255, green: 105.0/255, blue: 162.0/255, alpha: 1.0)
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadData()
        refreshControl.endRefreshing()
    }
    
    // Hide keyboard when scroll started
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    // Hide keyboard when search clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    // Hide keyboard when cancel button pressed
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.view.endEditing(true)
    }
    
}

