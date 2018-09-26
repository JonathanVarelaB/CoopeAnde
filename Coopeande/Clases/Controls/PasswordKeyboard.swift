//
//  PasswordKeyboard.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 25/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class PasswordKeyboard: UICollectionViewController {
    
    var itemsShowed :Array<NSNumber> = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
    var delegate : PasswordKeyDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        collectionView?.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 4
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemsShowed = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
        
        if( section < 3)
        {
            return 5
        }
        return 4
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: randomCellId(), for: indexPath) as UICollectionViewCell
        
        if let p = cell as? PasswordCell
        {
            // Configure the cell
            p.delegate = self.delegate
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
    ///MARK Utils
    func randomCellId() ->String
    {
        var result = "item"
        if( itemsShowed.count > 1)
        {
            let randData1   =  NSNumber(value: arc4random() as UInt32)
            let a = CGFloat( NSNumber(value: itemsShowed.count as Int).floatValue)
            let b = CGFloat( randData1.floatValue)
            let item : NSNumber = ( b.truncatingRemainder(dividingBy: a) - 1 + 1) as NSNumber!;
            result = result + itemsShowed[item.intValue].stringValue
            itemsShowed.remove(at: item.intValue)
        }
        else
        {
            result = result + itemsShowed[0].stringValue
            itemsShowed.remove(at: 0)
            itemsShowed.append(19)
            
        }
        return  result
    }
    
}
