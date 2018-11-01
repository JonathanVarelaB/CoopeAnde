//
//  CreditsViewController.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import SideMenu

class CreditsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    @IBOutlet weak var typeCreditCollection: UICollectionView!
    @IBOutlet weak var btnRequestCredit: UIButton!
    var colorIndex: Int = 0
    var dataResponse: CreditTypesByUser?
    var colorProgressDate: Int = 0 // 0 > default, 1 -> rojo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Créditos"
        self.setMenu()
        self.designAdjust()
        self.loadCreditTypes()
    }
    
    func designAdjust(){
        self.btnRequestCredit.layer.cornerRadius = 3
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if self.typeCreditCollection != nil {
            self.typeCreditCollection.reloadData()
        }
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
    
    @objc override func menuSide(sender: UIBarButtonItem) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        /*
        let cellWidth : CGFloat = 278.0
        let numberOfCells = floor(self.view.frame.size.width / cellWidth)
        let edgeInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets)
         */
        let space = (self.view.frame.size.width) / 2 - ((Constants.iPhone) ? 139 : 150)
        return UIEdgeInsetsMake(0, space, 0, space)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (Constants.iPhone) ? 278 : 300, height: (Constants.iPhone) ? 310 : UIApplication.shared.statusBarOrientation.isLandscape ? 340 : 380)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = self.dataResponse{
            return data.list.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colorArray = [UIColor(red:0.95, green:0.76, blue:0.09, alpha:1.0), UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0), UIColor(red:0.56, green:0.25, blue:0.60, alpha:1.0), UIColor(red:0.93, green:0.11, blue:0.18, alpha:1.0)]
        let cell: TipoProductoCell = self.typeCreditCollection.dequeueReusableCell(withReuseIdentifier: "detailCredit", for: indexPath) as! TipoProductoCell
        if let data = self.dataResponse?.list[indexPath.row]{
            cell.btnConsultar.tag = indexPath.row
            cell.lblDescription.text = "Realice el pago de su crédito"
            let name = data.name.replacingOccurrences(of: "Crédito", with: "")
            cell.lblTitle.text = "Crédito " + name
            var image = UIImage(named: data.imageId as String)
            if image == nil {
                image = UIImage(named: "otherCredit.png")
            }
            cell.imgLogo.image = image
            cell.viewService.backgroundColor = colorArray[data.color]
            cell.aliasTypeId = data.id
            cell.viewService.layer.cornerRadius = 10
            cell.btnConsultar.layer.cornerRadius = 3
        }
        return cell
    }

    func loadCreditTypes(){
        self.showBusyIndicator("Loading Data")
        ProxyManager.GetTypesByUser(success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.dataResponse = result.data!
                    self.typeCreditCollection.reloadData()
                    self.hideBusyIndicator()
                }
                else {
                    self.hideBusyIndicator()
                    if(self.sessionTimeOutException(result.code as String) == false){
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
    
    func loadCreditByType(type: TipoProductoCell){
        self.showBusyIndicator("Loading Data")
        let request = CreditByTypeRequest()
        request.creditTypeId = type.aliasTypeId
        ProxyManager.GetCreditByType(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    let count = result.data?.list.count
                    if count! > 0 {
                        //self.openCreditDetail(type: type, credit: (result.data?.list[0])!)
                        self.openCreditDetail(type: type, credits: ((result.data?.list)!))
                    }
                    else{
                        self.hideBusyIndicator()
                        self.showAlert("Error Title", messageKey: "No posee créditos")
                    }
                }
                else {
                    self.hideBusyIndicator()
                    if(self.sessionTimeOutException(result.code as String) == false){
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
    
    //func openCreditDetail(type: TipoProductoCell, credit: CreditByType){
    func openCreditDetail(type: TipoProductoCell, credits: Array<CreditByType>){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreditDetailViewController") as? CreditDetailViewController
        vc?.logo = type.imgLogo.image
        vc?.titleScreen = type.lblTitle.text!
        /*vc?.alias = credit.alias
        vc?.desc = credit.description
        vc?.owner = credit.owner
        vc?.operation = credit.operation
        vc?.iban = credit.iban
        vc?.totalQuota = credit.totalQuota.description + " meses"
        vc?.interest = Helper.formatAmount(credit.interests) + "%"
        vc?.pendingQuota = credit.pendingQuota.description
        vc?.policy = credit.pendingPolicy.description
        vc?.currency = credit.currencySign
        vc?.amount = Helper.formatAmount(credit.balanceAmount, currencySign: credit.currencySign)
        vc?.amountQuota = Helper.formatAmount(credit.quotaAmount, currencySign: credit.currencySign)
        if credit.maxPaymentDate != nil {
            vc?.date = self.paymentDate(date: credit.maxPaymentDate!)
            vc?.days = self.calculateDays(date: credit.maxPaymentDate!)
            if credit.cutOffDate != nil {
                vc?.progressDate = self.calculateProgressDate(minDate: credit.cutOffDate!, maxDate: credit.maxPaymentDate!)
                vc?.colorProgressDate = self.colorProgressDate
            }
        }*/
        vc?.credits = credits
        self.hideBusyIndicator()
        self.show(vc!, sender: nil)
    }
    /*
    func paymentDate(date: Date) -> String{
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date).description
        let month = Helper.months[calendar.component(.month, from: date) - 1]
        let year = calendar.component(.year, from: date).description
        return day + " " + month + " " + year
    }
    
    func calculateDays(date: Date) -> String{
        let days = Int((date.timeIntervalSinceNow / 60 / 60 / 24).rounded(.up))
        if days > 0 {
            return "En " + days.description + " día(s)"
        }
        else{
            if days == 0{
                return "Hoy"
            }
            else{
                self.colorProgressDate = 1
                return "Hace " + (days * -1).description + " día(s)"
            }
        }
    }
    
    func calculateProgressDate(minDate: Date, maxDate: Date) -> Float {
        let range = maxDate.timeIntervalSince(minDate)
        if range > 0 {
            var minToToday = Date().timeIntervalSince(minDate)
            minToToday = (minToToday < 0) ? 0 : minToToday
            return Float((minToToday / range))
        }
        return 0
    }
    */
    @IBAction func consultCredit(_ sender: UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let currentCell = self.typeCreditCollection.cellForItem(at: indexpath) as! TipoProductoCell
        self.loadCreditByType(type: currentCell)
    }
    
    @IBAction func requestCredit(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "http://www.coopeande1.com/solicitud-para-analisis-de-credito.html")!, options: [:], completionHandler: nil)
    }

}
