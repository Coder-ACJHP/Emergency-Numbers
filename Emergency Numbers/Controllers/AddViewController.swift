//
//  AddViewController.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 28.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit
import MessageUI

class AddViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var unitNameField: UITextField!
    @IBOutlet weak var unitNumberField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Draw border to better look
        saveButton.layer.borderWidth = 2
        saveButton.layer.cornerRadius = 4
        saveButton.layer.borderColor = UIColor.init(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.4).cgColor

    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if unitNameField.text != "" && unitNumberField.text != "" {
            //Add database methods to save
            DatabaseUtil.sharedInstance.save(name: unitNameField.text!, number: Int64(unitNumberField.text!)!)
            //Send notigication to info dev team
            sendEmail(unitName: unitNameField.text!, unitNumber: unitNumberField.text!)
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

extension AddViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail(unitName: String, unitNumber: String) {
        
        if MFMailComposeViewController.canSendMail() {
            let email = MFMailComposeViewController()
            email.mailComposeDelegate = self
            email.setToRecipients(["emnumbers-iraq@codeforiraq.org"])
            email.setMessageBody(createMessageTemplate(name: unitName, number: unitNumber), isHTML: true)
            
            //Show email sending page to user
            present(email, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "!حدث خطأ", message: "تم تسجيل الرقم المدرج بنجاح ولكن حدث خطأ في إرسال بريد الإشعار", preferredStyle: UIAlertControllerStyle.alert)
            let dismissButton = UIAlertAction(title: "تخطى", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(dismissButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // It is against Apple guidelines so we have send the email with user interaction!
    fileprivate func createMessageTemplate(name: String, number: String) -> String {
        let htmlMessageAsString = "<h1>مرحبا فريق التطوير!</h1><p>لقد قمت باضافة رقمًا جديدًا لقاعدة بياناتي الخاصة وأود أن أبلغكم أيضًا!</p><div><label>Unit name is: </label><span> " + name + "</span></div><div><label>Unit number is: </label><span> " + number + "</span></div>"
        return htmlMessageAsString
    }
    
}





