//
//  TableViewCell.swift
//  Emergency Numbers
//
//  Created by akademobi5 on 27.06.2018.
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
        container.layer.cornerRadius = 40
        container.layer.borderWidth = 2.0
        container.layer.borderColor = UIColor.init(red: 55.0/255, green: 105.0/255, blue: 162.0/255, alpha: 1.0).cgColor
        container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        //Add pan gesture to button can be swappable
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(slideButton))
        callButton.addGestureRecognizer(panRecognizer)
        
        //make the button rounded corners
        callButton.layer.cornerRadius = callButton.layer.bounds.width / 2
    }

    @objc func slideButton(panGesture: UIPanGestureRecognizer) {
        
        
        if panGesture.state == .ended || panGesture.state == .failed  || panGesture.state == .cancelled {
            callButton.layer.position = CGPoint(x: 38.5, y: 38.5) // restore button center
            callButton.transform = CGAffineTransform(rotationAngle: 0.0)
            unitName.layer.opacity = 1.0
        } else {
            var location = panGesture.location(in: container) // get pan location
            unitName.layer.opacity = unitName.layer.opacity - Float(location.x) / 400
            callButton.transform = CGAffineTransform(rotationAngle: location.x / 110)
            //Let the button swiping on 1 line
            if location.y > 37.66 || location.y < 37.66 {
                location.y = 37.66
            }
            //Put border to button from x point
            if location.x > 364.0 {
                location.x = 364.0
            }
            callButton.layer.position = location // set button to where finger is
            
            //O.K. button swapped lets make call
            if unitNumber != 0 {
                guard let number = URL(string: "tel://\(unitNumber)") else {return}
                UIApplication.shared.open(number, options: [ : ], completionHandler: nil)
            }
            
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
