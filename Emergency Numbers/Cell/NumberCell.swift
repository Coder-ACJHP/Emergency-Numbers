//
//  NumberCell.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 27.06.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit

class NumberCell: UICollectionViewCell {

    var unitNumber: Int = 0
    var fixedPosition: CGPoint!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var unitName: UILabel!
    @IBOutlet weak var cardbackground: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fixedPosition = CGPoint(x: callButton.layer.position.x + 4, y: callButton.layer.position.y + 2)
        
        //Add pan gesture to button can be swappable
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(slideButton))
        callButton.addGestureRecognizer(panRecognizer)
    }

    @objc func slideButton(slideGesture: UIPanGestureRecognizer) {
        
        let layerOpacity:Float = 1.0
        
        var location = slideGesture.location(in: self.contentView) // get pan location
        
        if slideGesture.state == .failed  || slideGesture.state == .cancelled {
            callButton.layer.position = fixedPosition // restore button center
            unitName.layer.opacity = layerOpacity
            
        } else if slideGesture.state == .ended {
            
            //O.K. button swapped lets make call
            guard let number = URL(string: "tel://\(unitNumber)") else {return}
            callButton.layer.position = fixedPosition // restore button center
            unitName.layer.opacity = layerOpacity
            UIApplication.shared.open(number, options: [ : ], completionHandler: nil)
            
        } else {
            
            unitName.layer.opacity = unitName.layer.opacity - Float(location.x) / 2500
            //Let the button swiping on 1 line
            if location.y > fixedPosition.y || location.y < fixedPosition.y {
                location.y = 36.0
            }
            
            if location.x > (cardbackground.bounds.width - callButton.frame.width / 2) { //Put border to button from x point
                location.x = (cardbackground.bounds.width - callButton.frame.width / 2)
            } else if location.x < fixedPosition.x {
                location.x = 36.0
            }
            callButton.layer.position = location // set button to where finger is
        }
        
        
        
    }
}
