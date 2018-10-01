//
//  SinpeMainViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/19/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import SideMenu

class SinpeMainViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var viewBody: UIView!
    var optionsMenu: Array<OptionMenuSinpe> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.setMainScreen()
        self.menuCollectionView.contentInset = UIEdgeInsetsMake(0, 40, 0, 40)
        self.loadOptions()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:1.0)
    }
    
    func setMainScreen(){
        self.title = "Coope Ande SINPE Móvil"
        self.setMenu()
        let subController = storyboard!.instantiateViewController(withIdentifier: "SinpeMainSubViewController") as! SinpeMainSubViewController
        self.removeController()
        addChildViewController(subController)
        subController.view.frame = self.viewBody.bounds
        self.viewBody.addSubview(subController.view)
    }
    
    func setMenu(){
        self.navigationItem.hidesBackButton = true
        let menuItem = UIBarButtonItem(image: UIImage(named: "menuCustom"), landscapeImagePhone: UIImage(named: "menuCustom"), style: .plain, target: self, action: #selector(menuSide(sender:)))
        self.navigationItem.leftBarButtonItem = menuItem
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        menuLeftNavigationController.menuWidth = view.frame.width * 0.80
        SideMenuManager.default.menuAddPanGestureToPresent(toView: menuLeftNavigationController.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: menuLeftNavigationController.view)
    }
    
    func backAction(){
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func returnBack(sender: UIBarButtonItem) {
        // view Default
        self.setMainScreen()
        for item in self.optionsMenu {
            item.selected = false
        }
        self.menuCollectionView.reloadData()
    }
    
    func loadOptions(){
        let opcion1 = OptionMenuSinpe(name: "Afiliación", image: UIImage(named: "afiliacion")!, color: UIColor(red:0.00, green:0.58, blue:0.56, alpha:1.0))
        let opcion2 = OptionMenuSinpe(name: "Transferencia", image: UIImage(named: "afiliacion")!, color: UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0))
        let opcion3 = OptionMenuSinpe(name: "Consulta de Movimientos", image: UIImage(named: "movimientos")!, color: UIColor(red:0.95, green:0.76, blue:0.09, alpha:1.0))
        let opcion4 = OptionMenuSinpe(name: "Cambio de Monto Máximo", image: UIImage(named: "montoMaximo")!, color: UIColor(red:0.93, green:0.11, blue:0.18, alpha:1.0))
        let opcion5 = OptionMenuSinpe(name: "Inactivación", image: UIImage(named: "afiliacion")!, color: UIColor(red:0.56, green:0.25, blue:0.60, alpha:1.0))
        self.optionsMenu = [opcion1, opcion2, opcion3, opcion4, opcion5]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.optionsMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.menuCollectionView.dequeueReusableCell(withReuseIdentifier: "OptionMenuSinpeCell", for: indexPath) as! OptionMenuSinpeCell
        cell.show(option: self.optionsMenu[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = self.optionsMenu[indexPath.item]
        if !option.selected {
            for item in self.optionsMenu {
                item.selected = false
            }
            option.selected = true
            self.setSubScreen(id: indexPath.item)
        }
        self.menuCollectionView.reloadData()
    }
    
    func setSubScreen(id: Int){
        self.backAction()
        var subController: BaseViewController!
        switch id {
        case 0:
            self.title = "Afiliación SINPE Móvil"
            subController = storyboard!.instantiateViewController(withIdentifier: "AffiliationViewController") as! AffiliationViewController
            break
        case 1:
            self.title = "Transferencia SINPE Móvil"
            subController = storyboard!.instantiateViewController(withIdentifier: "SinpeTransactionsViewController") as! SinpeTransactionsViewController
            break
        case 2:
            self.title = "Consulta de Movimientos"
            subController = storyboard!.instantiateViewController(withIdentifier: "SinpeMovementsViewController") as! SinpeMovementsViewController
            break
        case 3:
            self.title = "Configuración"
            subController = storyboard!.instantiateViewController(withIdentifier: "SinpeConfigurationViewController") as! SinpeConfigurationViewController
            break
        default: //4
            self.title = "Desafiliación SINPE Móvil"
            subController = storyboard!.instantiateViewController(withIdentifier: "DisaffiliationViewController") as! DisaffiliationViewController
            break
        }
        self.removeController()
        addChildViewController(subController)
        subController.view.frame = self.viewBody.bounds
        self.viewBody.addSubview(subController.view)
    }
    
    func removeController(){
        if self.childViewControllers.count > 0{
            let viewControllers:[UIViewController] = self.childViewControllers
            for viewContoller in viewControllers{
                viewContoller.willMove(toParentViewController: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParentViewController()
            }
        }
    }
    
}
