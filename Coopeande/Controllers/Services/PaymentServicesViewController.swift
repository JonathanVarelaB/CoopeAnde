//
//  PaymentServicesViewController.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno01 on 8/29/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import SideMenu

class PaymentServicesViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var typeServiceCollection: UICollectionView!
    var dataResultsFilter : Services?
    var colorIndex: Int = 0
    var dataResponse: Array<Service> = []
    var vc: DetailServiceViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pago de Servicios"
        self.setMenu()
        self.designAdjust()
        self.loadTypesServices()
        self.hideKeyboardWhenTappedAround()
    }

    func designAdjust(){
        self.txtSearch.layer.borderWidth = 0.7
        self.txtSearch.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtSearch.layer.cornerRadius = 4
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Lupa")
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        self.txtSearch.leftViewMode = UITextFieldViewMode.always
        self.txtSearch.addSubview(imageView)
        self.txtSearch.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.txtSearch.frame.height))
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
    
    @objc override func menuSide(sender: UIBarButtonItem) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Collection View
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth : CGFloat = 278.0
        
        let numberOfCells = floor(self.view.frame.size.width / cellWidth)
        let edgeInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        
        return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = self.dataResultsFilter{
            return data.list.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colorArray = [UIColor(red:0.95, green:0.76, blue:0.09, alpha:1.0), UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0), UIColor(red:0.56, green:0.25, blue:0.60, alpha:1.0), UIColor(red:0.93, green:0.11, blue:0.18, alpha:1.0)]
        let cell: TipoProductoCell = self.typeServiceCollection.dequeueReusableCell(withReuseIdentifier: "detailService", for: indexPath) as! TipoProductoCell
        if let data = self.dataResultsFilter?.list[indexPath.row]{
            cell.btnConsultar.tag = indexPath.row
            cell.lblDescription.text = data.description as String
            cell.lblTitle.text = data.name as String
            var image = UIImage(named: data.image as String)
            if image == nil {
                image = UIImage(named: "otros.png")
            }
            cell.imgLogo.image = image
            cell.viewService.backgroundColor = colorArray[data.color]
            cell.aliasTypeId = data.aliasTypeId as String
            cell.viewService.layer.cornerRadius = 10
            cell.btnConsultar.layer.cornerRadius = 3
        }
        return cell
    }
    
    func loadTypesServices(){
        self.showBusyIndicator("Loading Data")
        ProxyManager.AllServices ({
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.dataResultsFilter = result.data
                    self.dataResponse = (result.data?.list)!
                    self.typeServiceCollection.reloadData()
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
    
    func openDetailReceipt(){
        self.hideBusyIndicator()
        if self.vc != nil {
            self.show(self.vc!, sender: nil)
        }
    }
    
    @IBAction func filterServices(_ sender: UITextField) {
        let txt = self.txtSearch.text
        if txt == "" {
            self.dataResultsFilter?.list = (self.dataResponse)
        }
        else{
            self.dataResultsFilter?.list = (self.dataResponse.filter({ (service) -> Bool in
                let name: NSString = service.name
                return (name.range(of: txt!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            }))
        }
        self.typeServiceCollection.reloadData()
    }

    @IBAction func consultService(_ sender: UIButton) {
        self.vc = self.storyboard!.instantiateViewController(withIdentifier: "DetailServiceViewController") as? DetailServiceViewController
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let currentCell = self.typeServiceCollection.cellForItem(at: indexpath) as! TipoProductoCell
        self.vc?.logo = currentCell.imgLogo.image
        self.vc?.titleService = currentCell.lblTitle.text!
        let aliasId = currentCell.aliasTypeId
        self.vc?.idProduct = aliasId
        self.openDetailReceipt()
    }
    
}
