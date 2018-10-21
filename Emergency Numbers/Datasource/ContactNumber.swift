//
//  ContactNumber.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 28.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import Foundation

class ContactNumber {
    
    var id:Int64 = 0
    var description: String = ""
    var phoneNumber: Int64 = 0
    
    init() {}
    
    init(contactId: Int64, contactName: String, contactNumber: Int64) {
        self.id = contactId
        self.description = contactName
        self.phoneNumber = contactNumber
    }
    
    func toString() {
        print("Id: \(self.id), Description: \(self.description), Number: \(self.phoneNumber)")
    }
}
