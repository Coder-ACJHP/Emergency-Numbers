//
//  AboutUsViewController.swift
//  Emergency Numbers
//
//  Created by akademobi5 on 27.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var logoContainer: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        logoContainer.layer.cornerRadius = logoContainer.frame.width / 2
        
    }

}
