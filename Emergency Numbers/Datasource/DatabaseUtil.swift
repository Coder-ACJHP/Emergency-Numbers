//
//  DatabaseUtil.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 28.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import Foundation
import SQLite
import CSV

class DatabaseUtil {
    
    var database : Connection?
    static var sharedInstance = DatabaseUtil()
    
    let fileManager = FileManager.default
    let emergencyNumbers = Table("EmergencyNumbers")
    let id = Expression<Int64>("Id")
    let description = Expression<String>("Description")
    let phoneNumber = Expression<Int64>("PhoneNumber")
    
    
    init() {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/emergencyNumbers.sqlite3"
        
        if !fileManager.fileExists(atPath: path) {
            do {
                database = try Connection("\(path)")
                try database?.run(emergencyNumbers.create(temporary: false, ifNotExists: true, block: {
                    table in
                    table.column(id, primaryKey: true)
                    table.column(phoneNumber)
                    table.column(description)
                }))
                print("Info: Database created successfully.")
                
                //Database is exist than populate it
                let isPopulated : Bool = UserDefaults.standard.bool(forKey: "Database populated")
                if isPopulated == false {
                    self.prePopulateTable()
                }
                
            } catch {
                showErrorViaAlert(error: error)
            }
        } else {
            
            do {database = try Connection("\(path)")} catch {
                showErrorViaAlert(error: error)
            }
 
        }
    }
    
    func findById(entityId: Int64) -> Row? {
        var foundedRow: Row?
        do {
            let query = emergencyNumbers.filter(id == entityId)
            let data = try database?.pluck(query)
            foundedRow = data
        } catch {
            showErrorViaAlert(error: error)
            foundedRow = nil
        }
        return foundedRow
    }
    
    func findByCityName(name: String) -> [Row] {
        do {
            let query = emergencyNumbers.where(description.like("%\(name)"))            
            return Array(try database!.prepare(query))
        } catch {
            showErrorViaAlert(error: error)
            return [Row]()
        }
    }
    
    func fetchAll() -> [Row] {
        do {
            return Array(try database!.prepare(emergencyNumbers))
        } catch {
            showErrorViaAlert(error: error)
            return [Row]()
        }
    }
    
    func save(name: String, number: Int64) throws {
        do {
            try database?.run(emergencyNumbers.insert(description <- name, phoneNumber <- number))
        } catch {
            showErrorViaAlert(error: error)
        }
    }
    
    func deleteById(entityId: Int64) {
        do {
            let singleRow =  emergencyNumbers.filter(id == entityId)
            try database?.run(singleRow.delete())
        } catch {
            showErrorViaAlert(error: error)
        }
    }
    
    func prePopulateTable() {
        if let filepath = Bundle.main.path(forResource: "EmergencyNumbers", ofType: "csv") {
            let stream = InputStream(fileAtPath: filepath)!
            let csv = try! CSVReader(stream: stream)
            if !(csv.next()?.isEmpty)! {
                while let row = csv.next() {
                    do {
                        try self.save(name: row[2], number: Int64(row[1])!)
                    } catch {
                        print("Error! \(error.localizedDescription)")
                    }
                }
                //Save some values to can now it's already done for another sessions
                UserDefaults.standard.set(true, forKey: "Database populated")
                
                print("Database populated successfully.")
            } else {
                showCustomErrorViaAlert(error: "CSV file is empty!\nCannot populate table!")
            }
        } else {
            showCustomErrorViaAlert(error: "Cannot find cvs file path!")
        }
    }
    
    func showErrorViaAlert(error: Error) {
        let alert = UIAlertController(title: "!حدث خطأ", message: "\(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
        let dismissButton = UIAlertAction(title: "أغلق", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(dismissButton)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func showCustomErrorViaAlert(error: String) {
        let alert = UIAlertController(title: "Fatal error!", message: error, preferredStyle: UIAlertControllerStyle.alert)
        let dismissButton = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(dismissButton)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
}



