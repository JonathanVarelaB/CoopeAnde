//
//  PasswordKeyboard.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 25/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class PasswordKeyboard: UICollectionViewController {
    
    var itemsShowed: Array<NSNumber> = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
    var delegate: PasswordKeyDelegate?
    var section: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.layer.cornerRadius = 4
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async() {
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.section == "login" && UIApplication.shared.statusBarOrientation.isLandscape) ? 4 : 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemsShowed = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
        return (self.section == "login" && UIApplication.shared.statusBarOrientation.isLandscape) ? 5 : 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: randomCellId(), for: indexPath) as UICollectionViewCell
        cell.layer.cornerRadius = 4
        if let p = cell as? PasswordCell{
            p.delegate = self.delegate
        }
        return cell
    }
    
    func randomCellId() -> String{
        var result = "item"
        if itemsShowed.count > 1 {
            let randData1   =  NSNumber(value: arc4random() as UInt32)
            let a = CGFloat( NSNumber(value: itemsShowed.count as Int).floatValue)
            let b = CGFloat( randData1.floatValue)
            let item : NSNumber = ( b.truncatingRemainder(dividingBy: a) - 1 + 1) as NSNumber!;
            result = result + itemsShowed[item.intValue].stringValue
            itemsShowed.remove(at: item.intValue)
        }
        else{
            result = result + itemsShowed[0].stringValue
            itemsShowed.remove(at: 0)
            itemsShowed.append(19)
            itemsShowed.append(20)
        }
        return  result
    }
    
}
