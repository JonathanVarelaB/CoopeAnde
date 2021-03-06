//
//  SelectAccountServiceViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class SelectAccountServiceViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var detailServiceViewController: BaseViewController?
    var productSelected: SelectableProduct? = nil
    var products: Array<SelectableProduct>? = []
    var productType: String = ""
    var sectionType: String = ""
    var titleTypeCredit: String = ""
    var transactionType: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        switch (self.productType) {
        case "tipoRecibo":
            self.title = "Tipo de Recibo"
            if self.productSelected != nil {
                self.productSelected = self.productSelected as! PayCreditType
            }
            break;
        case "credito":
            self.title = "Mis Créditos"//self.titleTypeCredit
            if self.productSelected != nil {
                self.productSelected = self.productSelected as! CreditByType
            }
            break;
        default:
            self.title = (self.sectionType == "sinpeAfiliacion") ? "Lista de Cuentas" : (self.sectionType == "sinpeDesafiliacion") ? "Teléfonos Afiliados" : (self.sectionType == "transaccionDestino") ? "Cuenta Destino" : "Cuenta Origen"
            if self.productSelected != nil {
                self.productSelected = self.productSelected as! Account
            }
            break;
        }
        if self.productSelected == nil {
            for item in self.products! {
                item.selected = false
            }
        }
        self.backAction()
    }
    
    func backAction(){
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func returnBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkBoxAction(_ sender: UIButton) {
        self.checkBox(index: sender.tag)
    }
    
    func checkBox(index: Int){
        let action: Bool = self.products![index].selected
        for item in self.products! {
            item.selected = false
        }
        self.products![index].selected = !action
        self.productSelected = nil
        if !action {
            self.productSelected = self.products?[index]
        }
        self.tableView.reloadData()
        if self.productSelected != nil{
            switch self.sectionType {
            case "servicios":
                self.detailServiceViewController = self.detailServiceViewController as! DetailServiceViewController
                break
            case "creditos":
                self.detailServiceViewController = self.detailServiceViewController as! PayCreditDetailViewController
                break
            case "sinpeAfiliacion":
                self.detailServiceViewController = self.detailServiceViewController as! AffiliationViewController
                break
            case "sinpeTransaction":
                self.detailServiceViewController = self.detailServiceViewController as! SinpeTransactionsViewController
                break
            case "sinpeDesafiliacion":
                self.detailServiceViewController = self.detailServiceViewController as! DisaffiliationViewController
                break
            case "transaccionDestino":
                self.detailServiceViewController = self.detailServiceViewController as! TransactionsViewController
                break
            case "transaccionOrigen":
                self.detailServiceViewController = self.detailServiceViewController as! TransactionsViewController
                break
            case "pagoCredito":
                self.detailServiceViewController = self.detailServiceViewController as! CreditDetailViewController
                break
            default:
                print("default")
                break
            }
            self.detailServiceViewController?.assignProductSelect(product: self.productSelected!, type: self.productType)
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.detailServiceViewController?.cleanProductSelect(type: self.productType)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.checkBox(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.products?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return (self.sectionType == "sinpeTransaction") || (self.sectionType == "transaccionDestino") ? 117 : 100
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async() {
            if self.tableView != nil {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = 100
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SelectFromAccountCell", for: indexPath) as! SelectFromAccountCell
        var productToShow: SelectableProduct? = nil
        productToShow = (self.products![indexPath.row])
        switch (self.productType) {
        case "tipoRecibo":
            cell.showPayCreditType(productToShow as! PayCreditType)
            break;
        case "credito":
            cell.showCreditType(productToShow as! CreditByType)
            break;
        default:
            cell.showAccount(productToShow as! Account, section: self.sectionType, transactionType: self.transactionType)
            break;
        }
        cell.btnCheckBox.tag = indexPath.row
        /*
        let border = CALayer()
        border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border.frame = CGRect(x: 15, y: (cell.frame.size.height) - 1, width: UIScreen.main.bounds.width - 30, height: 1)
        border.borderWidth = 1
        cell.layer.addSublayer(border)
        cell.layer.masksToBounds = true
         */
        return cell
    }
    
}
