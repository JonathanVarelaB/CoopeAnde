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

    override func viewDidLoad() {
        super.viewDidLoad()
        switch (self.productType) {
            case "cuenta":
                self.title = (self.sectionType == "sinpeAfiliacion") ? "Lista de Cuentas" : (self.sectionType == "sinpeDesafiliacion") ? "Teléfonos Afiliados" : (self.sectionType == "transaccionDestino") ? "Cuenta Destino" : "Cuenta Origen"
                if self.productSelected != nil {
                    self.productSelected = self.productSelected as! Account
                }
                break;
            default:
                self.title = "Tipo de Recibo"
                if self.productSelected != nil {
                    self.productSelected = self.productSelected as! PayCreditType
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
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SelectFromAccountCell", for: indexPath) as! SelectFromAccountCell
        var productToShow: SelectableProduct? = nil
        productToShow = (self.products![indexPath.row])
        switch (self.productType) {
        case "cuenta":
            cell.showAccount(productToShow as! Account, section: self.sectionType)
            break;
        default:
            cell.showPayCreditType(productToShow as! PayCreditType)
            break;
        }
        cell.btnCheckBox.tag = indexPath.row
        let border = CALayer()
        border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border.frame = CGRect(x: 15, y: (cell.frame.size.height) - 1, width:  (cell.frame.size.width) - 30, height: 1)
        border.borderWidth = 1
        cell.layer.addSublayer(border)
        cell.layer.masksToBounds = true
        return cell
    }
    
}
