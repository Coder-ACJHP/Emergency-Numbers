//
//  TableViewCell.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 27.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var unitNumber: Int = 0
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var unitName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Set container borders and masks
        container.layer.cornerRadius = 4
        container.layer.borderWidth = 0.5
        container.layer.borderColor = UIColor.gray.cgColor
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 1
        container.layer.shadowOffset = CGSize(width: 0, height: 1)
        container.layer.shadowRadius = 4
        container.layer.shadowPath = UIBezierPath(rect: container.bounds).cgPath
        container.layer.shouldRasterize = true
        //UIColor.init(red: 55.0/255, green: 105.0/255, blue: 162.0/255, alpha: 1.0).cgColor
        //container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        //Add pan gesture to button can be swappable
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(slideButton))
        callButton.addGestureRecognizer(panRecognizer)
        
        callButton.layer.borderWidth = 2
        callButton.layer.borderColor = UIColor.init(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.4).cgColor
        //make the button rounded corners
       // callButton.layer.cornerRadius = callButton.layer.bounds.width / 2
    }

    @objc func slideButton(panGesture: UIPanGestureRecognizer) {
        
        var location = panGesture.location(in: container) // get pan location
        
        if panGesture.state == .failed  || panGesture.state == .cancelled {
            callButton.layer.position = CGPoint(x: 38.0, y: 38.0) // restore button center
            unitName.layer.opacity = 1.0
        } else if panGesture.state == .ended {
            //O.K. button swapped lets make call
            guard let number = URL(string: "tel://\(unitNumber)") else {return}
            callButton.layer.position = CGPoint(x: 38.0, y: 38.0) // restore button center
            unitName.layer.opacity = 1.0
            UIApplication.shared.open(number, options: [ : ], completionHandler: nil)
            print(number)
            print("Making call....")
        } else {
            
            unitName.layer.opacity = unitName.layer.opacity - Float(location.x) / 2500
            //Let the button swiping on 1 line
            if location.y > 38.0 || location.y < 38.0 {
                location.y = 38.0
            }
            //Put border to button from x point
            if location.x > 364.0 {
                location.x = 364.0
            } else if location.x < 38.0 {
                location.x = 38.0
            }
            callButton.layer.position = location // set button to where finger is
        }
        
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
