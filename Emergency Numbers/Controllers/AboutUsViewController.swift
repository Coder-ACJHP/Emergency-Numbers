//
//  AboutUsViewController.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 27.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var whoUsIcon: UIImageView!
    @IBOutlet weak var targetIcon: UIImageView!
    @IBOutlet weak var sourceCodeIcon: UIImageView!
    @IBOutlet weak var emailUsIcon: UIImageView!
    lazy var iconList = [whoUsIcon, targetIcon, sourceCodeIcon, emailUsIcon]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareUserInterface()
        
    }
    
    fileprivate func prepareUserInterface() {
        
        for index in 0..<iconList.count {
            
            let imageView = iconList[index]
            imageView?.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            tapGesture.name = "action\(index)"
            imageView?.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc fileprivate func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        guard let imageView = gestureRecognizer.view as? UIImageView else { return }
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseInOut], animations: {
            imageView.transform = imageView.transform.scaledBy(x: 0.95, y: 0.95)
        }) { (_) in
            imageView.transform = .identity
            
            switch gestureRecognizer.name {
            case "action0":
                UIApplication.shared.open(URL(string: "https://codeforiraq.org/about-team/")!, options: [:], completionHandler: nil)
            case "action1":
                UIApplication.shared.open(URL(string: "http://codeforiraq.herokuapp.com")!, options: [:], completionHandler: nil)
            case "action2":
                UIApplication.shared.open(URL(string: "https://github.com/Coder-ACJHP/Emergency-Numbers")!, options: [:], completionHandler: nil)
            case "action3":
                let email = "info@codeforiraq.org"
                UIApplication.shared.open(URL(string: "mailto:\(email)")!, options: [:], completionHandler: nil)
            default: break
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
