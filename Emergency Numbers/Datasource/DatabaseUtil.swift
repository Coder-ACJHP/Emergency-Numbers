//
//  DatabaseUtil.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 28.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import Foundation
import SQLite

class DatabaseUtil {
    
    var database : Connection?
    static var sharedInstance = DatabaseUtil()
    
    let emergencyNumbers = Table("EmergencyNumbers")
    let id = Expression<Int64>("id")
    let unitName = Expression<String>("unitName")
    let unitNumber = Expression<Int64>("unitNumber")
    
    
    init() {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        print(path)
        
        do {
            database = try Connection("\(path)/emergencyNumbers.sqlite3")
            try database?.run(emergencyNumbers.create(temporary: false, ifNotExists: true, block: {
              table in
                table.column(id)
                table.column(unitName)
                table.column(unitNumber)
            }))
        } catch {
            
            showErrorViaAlert(error: error)
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
    
    func fetchAll() -> [Row] {
        do {
            return Array(try database!.prepare(emergencyNumbers))
        } catch {
            showErrorViaAlert(error: error)
            return [Row]()
        }
    }
    
    func save(name: String, number: Int64) {
        do {
            try database?.run(emergencyNumbers.insert(unitName <- name, unitNumber <- number))
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
    
    func showErrorViaAlert(error: Error) {
        let alert = UIAlertController(title: "!حدث خطأ", message: "\(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
        let dismissButton = UIAlertAction(title: "أغلق", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(dismissButton)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
}



