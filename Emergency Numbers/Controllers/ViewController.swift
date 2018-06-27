//
//  ViewController.swift
//  Emergency Numbers
//
//  Created by akademobi5 on 27.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    lazy var searchBar = UISearchBar()
    var contactListNames = [String]()
    var contactListNumbers = [Int]()
    @IBOutlet var dataContainer: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataContainer.delegate = self
        dataContainer.dataSource = self
        contactListNames.append("Ambulance")
        contactListNumbers.append(23444)
        
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListNumbers.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Add your logic here for removing
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform segue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singleCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        singleCell.unitName.text = contactListNames[indexPath.row]
        singleCell.unitNumber = contactListNumbers[indexPath.row]
        return singleCell
    }
    
}

