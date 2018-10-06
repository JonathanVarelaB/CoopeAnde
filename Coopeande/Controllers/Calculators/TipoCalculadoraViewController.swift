//
//  TipoCalculadoraViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import SideMenu

class TipoCalculadoraViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Calculadora"
        self.setDesign()
        self.setMenu()
    }
    
    func setDesign(){
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: (Constants.iPad) ? 0 : -14)
        UITabBar.appearance().selectionIndicatorImage = self.getImageWithColorPosition(color: UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2), size: CGSize(width:(UIScreen.main.bounds.width/3.5),height: 49), lineSize: CGSize(width:(UIScreen.main.bounds.width/3.5), height:4))
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0), NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13) as Any], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0), NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13) as Any], for: .selected)
        let border = CALayer()
        border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border.frame = CGRect(x: 15, y: 50, width: UIScreen.main.bounds.width - 30, height: 1)
        border.borderWidth = 1
        tabBar.layer.addSublayer(border)
    }
    
    func getImageWithColorPosition(color: UIColor, size: CGSize, lineSize: CGSize) -> UIImage {
        let rect = CGRect(x:0, y: 0, width: size.width, height: size.height)
        let rectLine = CGRect(x:0, y:size.height-lineSize.height,width: lineSize.width,height: lineSize.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        color.setFill()
        UIRectFill(rectLine)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func setMenu(){
        self.navigationItem.hidesBackButton = true
        let menuItem = UIBarButtonItem(image: UIImage(named: "menuCustom"), landscapeImagePhone: UIImage(named: "menuCustom"), style: .plain, target: self, action: #selector(menuSide(sender:)))
        self.navigationItem.leftBarButtonItem = menuItem
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        menuLeftNavigationController.menuWidth = (Constants.iPhone) ? view.frame.width * 0.80 : 350
        SideMenuManager.default.menuAddPanGestureToPresent(toView: menuLeftNavigationController.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: menuLeftNavigationController.view)
    }
    
    @objc func menuSide(sender: UIBarButtonItem) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
    }
}
