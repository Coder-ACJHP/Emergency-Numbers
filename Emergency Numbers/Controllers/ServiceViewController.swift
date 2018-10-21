//
//  ServiceViewController.swift
//  Emergency Numbers
//
//  Created by Onur Işık on 20.10.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit
import StoreKit

class ServiceViewController: UIViewController {

    var contextMenuIsShowed = true
    @IBOutlet var contextualMenu: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      self.adjustContextMenu()
        
    }

    private func adjustContextMenu() {
        
        contextualMenu.alpha = 0
        contextualMenu.isHidden = true
        contextualMenu.frame = CGRect(x: 30, y: 25, width: 180, height: 40)
        self.view.addSubview(contextualMenu)
        self.view.bringSubview(toFront: contextualMenu)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if contextMenuIsShowed {
            self.hideContexualMenu()
            contextMenuIsShowed = !contextMenuIsShowed
        }
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if contextMenuIsShowed {
            
            self.showContexualMenu()
            
        } else {
            
            self.hideContexualMenu()
        }
        
        contextMenuIsShowed = !contextMenuIsShowed
    }
    
    private func showContexualMenu() {
        
        self.contextualMenu.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.contextualMenu.alpha = 1
        }, completion: nil)
    }
    
    private func hideContexualMenu() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.contextualMenu.alpha = 0
        }) { (_) in
            self.contextualMenu.isHidden = true
        }
    }
    
    @IBAction func servicesButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func emergencyButtonPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func contextualMenuRateApp(_ sender: Any) {
        
        SKStoreReviewController.requestReview()
    }
    
}
