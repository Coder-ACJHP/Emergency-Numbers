//
//  CityViewController.swift
//  Emergency Numbers
//
//  Created by Onur Işık on 20.10.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit
import StoreKit
import VegaScrollFlowLayout


/* GLOBAL VARIABLES */
var choosenCityName: String!

class CityViewController: UIViewController {

    var contextMenuIsShowed = false
    @IBOutlet var contextualMenu: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let cellBackgroundImage = UIImage(named: "CellBackground")
    let citiesNamesList = ["الأنبار", "بابل", "بغداد", "البصرة", "ذي قار", "ديالى", "دهوك", "أربيل", "كربلاء", "كركوك", "ميسان", "المثنى", "النجف", "نينوى", "القادسية", "صلاح الدين", "السليمانية", "واسط"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.adjustCollectionViewSettings()
        
        self.adjustContextMenu()
        
    }

    private func adjustCollectionViewSettings() {
        
        let layout = VegaScrollFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 87)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        if !contextMenuIsShowed {
            
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
    
    @IBAction func contexualMenuFindMe(_ sender: Any) {
        
    }
    
    @IBAction func contextMenuRateApp(_ sender: Any) {
        
        SKStoreReviewController.requestReview()
    }
}

extension CityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citiesNamesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleCell", for: indexPath) as! CityCell
        cell.backgroundImage.image = cellBackgroundImage
        cell.cityNameLabel.text = citiesNamesList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CityCell
        choosenCityName = cell.cityNameLabel.text!
        
        self.performSegue(withIdentifier: "toChooseService", sender: self)
    }
    
}
