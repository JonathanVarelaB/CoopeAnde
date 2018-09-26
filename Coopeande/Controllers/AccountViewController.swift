//
//  AccountViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 19/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import SideMenu


class AccountViewController: BaseAccountViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var window: UIWindow?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cuentas"
        
        self.navigationItem.hidesBackButton = true
        //let menuItem = UIBarButtonItem(title: "Menú", style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuSide(sender:)))
        let menuItem = UIBarButtonItem(image: UIImage(named: "Menu"), landscapeImagePhone: UIImage(named: "Menu"), style: .plain, target: self, action: #selector(menuSide(sender:)))
        self.navigationItem.leftBarButtonItem = menuItem
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        menuLeftNavigationController.menuWidth = view.frame.width * 0.80
        SideMenuManager.default.menuAddPanGestureToPresent(toView: menuLeftNavigationController.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: menuLeftNavigationController.view)
    }

    
    @objc override func menuSide(sender: UIBarButtonItem) {
        print("Entro aqui")
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = dataResponse
        {
            return data.count.intValue
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let CellIdentifier = "accounts"
        
        let cell: AccountCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! AccountCell
        if let data = dataResponse
        {
            cell.show( data.list[(indexPath as NSIndexPath).row])
            
            
        }
        return cell;
    }
   /* func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }*/
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.row > 0 {
            let width = (collectionView.frame.width-5)/2
            let height : CGFloat = 180.0
            return CGSize(width: width, height: height)
        }else {
            let width = collectionView.frame.width
            let height : CGFloat = 180.0
            return CGSize(width: width, height: height)
        }
        
        
       /* if (dataResponse?.count.intValue)! % 2 == 0 {
            
            let width = (collectionView.frame.width-20)/2
            let height : CGFloat = 100.0
            return CGSize(width: width, height: height)
            
        }else {
            
            if (dataResponse?.count.intValue)!-1 == indexPath.row {
                let width = collectionView.frame.width-10
                let height : CGFloat = 100.0
                return CGSize(width: width, height: height)
            }else{
                let width = (collectionView.frame.width-20)/2
                let height : CGFloat = 100.0
                return CGSize(width: width, height: height)
            }
        }*/
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0,0,0,0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
}
