//
//  AccountsViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/29/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import SideMenu

class AccountsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var accounts: Array<Account> = []
    var colorArray: Array<UIColor> = [UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0), UIColor(red:0.95, green:0.76, blue:0.09, alpha:1.0), UIColor(red:0.93, green:0.11, blue:0.18, alpha:1.0), UIColor(red:0.56, green:0.25, blue:0.60, alpha:1.0), UIColor(red:0.00, green:0.58, blue:0.56, alpha:1.0)]
    var imageArray: Array<UIImage> = [UIImage(named: "plus-blue")!, UIImage(named: "plus-yellow")!, UIImage(named: "plus-red")!, UIImage(named: "plus-purple")!, UIImage(named: "plus-green")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProxyManagerData.actualController = self
        self.title = "Cuentas"
        self.setMenu()
        self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0)
        self.loadAccounts()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:1.0)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AccountCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "AccountCell", for: indexPath) as! AccountCell
        let a = self.accounts[indexPath.row]
        cell.show(account: a, color: self.colorArray[a.color], image: self.imageArray[a.color])
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let a = self.accounts[indexPath.row]
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreditMovementsViewController") as! CreditMovementsViewController
        vc.actualAmount = Helper.formatAmount(a.availableBalance, currencySign: a.currencySign.description)
        vc.alias = a.aliasName.description
        vc.subTitle = "Saldo Actual"
        vc.type = a.typeDescription.description
        vc.operation = a.iban.description
        vc.currency = a.currencySign.description
        vc.account = a.account.description
        vc.sectionType = 2
        self.show(vc, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 || ((self.accounts.count % 2 == 0) && self.accounts.count - 1 == indexPath.row) {
            let width: CGFloat = self.collectionView.frame.width - 16 //304.0
            let height: CGFloat = (Constants.iPhone) ? 214.0 : 280
            return CGSize(width: width, height: height)
        }else {
            let width: CGFloat = (self.collectionView.frame.width - 36) / 2 //142.0
            let height: CGFloat = (Constants.iPhone) ? 214.0 : 280
            return CGSize(width: width, height: height)
        }
    }
    
    func loadAccounts(){
        self.showBusyIndicator("Loading Data")
        ProxyManager.AllBalances ({
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess{
                    self.accounts = (result.data?.list)!
                    //self.accounts.remove(at: 0)
                    self.hideBusyIndicator()
                    if (self.accounts.count) < 1 {
                        self.showAlert("Atención", messageKey: "No se encontraron cuentas asociadas")
                    }
                    self.collectionView.reloadData()
                }
                else{
                    self.hideBusyIndicator()
                    if(!self.sessionTimeOutException(result.code.description, message: result.message.description)){
                        self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                    }
                }
            })
        }, failure: { (error) -> Void in
            DispatchQueue.main.async {
                self.hideBusyIndicator()
                self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
            }
        })
    }
    
}
