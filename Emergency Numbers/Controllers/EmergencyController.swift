//
//  ViewController.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 27.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit
import SQLite
import VegaScrollFlowLayout

class EmergencyController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var singleCell = NumberCell()
    var contactList: [ContactNumber] = []
    //Refresh data table
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(EmergencyController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    @IBOutlet var dataContainer: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adjustCollectionViewSetup()
        
        searchBar.delegate = self
        
        //Populate table
        loadData()
        
        // Request review
        StoreReviewHelper.checkAndAskForReview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dataContainer.contentInset = UIEdgeInsetsMake(0, 0, 30, 0)
    }
    
    private func adjustCollectionViewSetup() {
        
        let layout = VegaScrollFlowLayout()
        dataContainer.collectionViewLayout = layout
        dataContainer.delegate = self
        dataContainer.dataSource = self
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: dataContainer.frame.width, height: 75)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        dataContainer.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(EmergencyController.loadData), name: NSNotification.Name(rawValue: "addedNewNumber"), object: nil)
        self.refreshControl.tintColor = self.searchBar.barTintColor
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func backButonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func loadData() {
        
        //Clean all arrays
        contactList.removeAll(keepingCapacity: false)
        
        //Fetch all rows and append them to arrays
        let allData = DatabaseUtil.sharedInstance.fetchAll()
        for row in allData {
            do {
                
                if !citiesNamesList.contains(where: try row.get(DatabaseUtil.sharedInstance.description).contains) {
                    contactList.append(ContactNumber(
                        contactId: Int64(try row.get(DatabaseUtil.sharedInstance.id)),
                        contactName: String(try row.get(DatabaseUtil.sharedInstance.description)),
                        contactNumber: Int64(try row.get(DatabaseUtil.sharedInstance.phoneNumber)))
                    )
                }
                
            }catch {
                print(error.localizedDescription)
            }
        }
        
        dataContainer.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        singleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as! NumberCell
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
        }
    }
    
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

