//
//  ServiceViewController.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 20.10.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit
import StoreKit

class EntryViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var contextMenu: UIView!
    
    private var menuIsHidden: Bool = true
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        return tapGesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contextMenu.isHidden = true
        contextMenu.alpha = 0
        
        self.view.addGestureRecognizer(tapGesture)
    }

    
    fileprivate func showMenu() {
        self.contextMenu.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn], animations: {
            self.contextMenu.alpha = 1
        }, completion: nil)
    }
    
    fileprivate func hideMenu() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut], animations: {
            self.contextMenu.alpha = 0
        }, completion: nil)
        self.contextMenu.isHidden = true
    }

    @objc fileprivate func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        if gestureRecognizer.view != contextMenu {
            self.hideMenu()
            menuIsHidden = !menuIsHidden
        }
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        
        if menuIsHidden {
            showMenu()
        } else {
            hideMenu()
        }
        
        menuIsHidden = !menuIsHidden
    }
    
    @IBAction func rateButtonPressed(_ sender: UIButton) {
        SKStoreReviewController.requestReview()
        hideMenu()
        menuIsHidden = !menuIsHidden
    }
}
