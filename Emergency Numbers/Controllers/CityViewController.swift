//
//  CityViewController.swift
//  Emergency Numbers
//
//  Created by Coder ACJHP on 20.10.2018.
//  Copyright © 2018 codeForIraq. All rights reserved.
//

import UIKit
import StoreKit
import VegaScrollFlowLayout


/* GLOBAL VARIABLES */
var choosenCityName: String = ""
let citiesNamesList = ["الأنبار", "بابل", "بغداد", "البصرة", "ذي قار", "ديالى", "دهوك", "اربيل", "كربلاء", "كركوك", "ميسان", "المثنى", "النجف", "نينوى", "القادسية", "صلاح الدين", "السليمانية", "واسط"]

class CityViewController: UIViewController {

    
    
    @IBOutlet weak var contextMenu: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var menuIsHidden: Bool = true
    private let SEGUE_IDENTIFIER: String = "toChooseNumber"
    let cellBackgroundImage = UIImage(named: "CellBackground")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.adjustCollectionViewSettings()
        
        contextMenu.isHidden = true
        contextMenu.alpha = 0
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0)
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
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if menuIsHidden {
            showMenu()
        } else {
            hideMenu()
        }
        
        menuIsHidden = !menuIsHidden
    }

    
    @IBAction func menuBackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuFindMePressed(_ sender: UIButton) {
        
    }
    
    @IBAction func rateButtonPressed(_ sender: UIButton) {
        SKStoreReviewController.requestReview()
        hideMenu()
        menuIsHidden = !menuIsHidden
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
            
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)        
        self.performSegue(withIdentifier: "toChooseNumber", sender: self)
    }
    
}
