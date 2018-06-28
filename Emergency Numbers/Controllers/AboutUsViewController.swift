//
//  AboutUsViewController.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 27.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var secondImageContainer: UIImageView!
    @IBOutlet weak var logoContainer: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        logoContainer.layer.cornerRadius = logoContainer.frame.width / 2
        logoContainer.layer.borderWidth = 1.0
        logoContainer.layer.borderColor = UIColor.lightGray.cgColor
        secondImageContainer.layer.cornerRadius = secondImageContainer.frame.width / 2
        secondImageContainer.layer.borderWidth = 1.0
        secondImageContainer.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func linkClicked(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://codeforiraq.org")!, options: [:], completionHandler: nil)
    }
    @IBAction func sourceCodeClicked(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://github.com/Coder-ACJHP/Emergency-Numbers")!, options: [:], completionHandler: nil)
    }
}
