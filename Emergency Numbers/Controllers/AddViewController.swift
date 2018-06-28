//
//  AddViewController.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 28.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var unitNameField: UITextField!
    @IBOutlet weak var unitNumberField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if unitNameField.text != "" && unitNumberField.text != "" {
            //Add database methods to save
            DatabaseUtil.sharedInstance.save(name: unitNameField.text!, number: Int64(unitNumberField.text!)!)
            //Perform segue to return old page
            sendNotification()
        } else {
            let alert = UIAlertController(title: "!حدث خطأ", message: "تأكد من ملئ جميع الفراغات", preferredStyle: UIAlertControllerStyle.alert)
            let dismissButton = UIAlertAction(title: "أغلق", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(dismissButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func sendNotification() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addedNewNumber"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
