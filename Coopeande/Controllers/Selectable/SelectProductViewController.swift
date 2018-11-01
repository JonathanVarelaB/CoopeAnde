//
//  SelectProductViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class SelectProductViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var productSelected: SelectableProduct? = nil
    var products: Array<SelectableProduct>? = []
    var mainViewController: BaseViewController?
    var productType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        switch (self.productType) {
            case "credito":
                self.title = "Tipo de Crédito"
                self.mainViewController = self.mainViewController as! CreditCalculatorViewController
                if self.productSelected != nil {
                    self.productSelected = self.productSelected as! CreditType
                }
                break;
            case "calculo":
                self.title = "Tipo de Cálculo"
                self.mainViewController = self.mainViewController as! SavingCalculatorViewController
                if self.productSelected != nil {
                    self.productSelected = self.productSelected as! CalculatorType
                }
                break;
            default:
                self.title = "Tipo de Ahorro"
                self.mainViewController = self.mainViewController as! SavingCalculatorViewController
                if self.productSelected != nil {
                    self.productSelected = self.productSelected as! SavingType
                }
                break;
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkBoxAction(_ sender: UIButton) {
        self.checkBox(index: sender.tag)
    }
    
    func checkBox(index: Int){
        let action: Bool = (products![index].selected)
        for item in products! {
            item.selected = false
        }
        products![index].selected = !action
        self.productSelected = nil
        if !action {
            self.productSelected = products?[index]
        }
        self.tableView.reloadData()
        if self.productSelected != nil{
            self.navigationController?.popViewController(animated: true)
            self.mainViewController?.assignProductSelect(product: self.productSelected!, type: self.productType)
        }
        else{
            self.mainViewController?.cleanProductSelect(type: self.productType)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.checkBox(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
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
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CreditCell", for: indexPath) as! CreditCell
        var productToShow: SelectableProduct? = nil
        productToShow = (self.products![indexPath.row])
        switch (self.productType) {
            case "credito":
                cell.show(product: self.productType, type: (productToShow! as! CreditType).name, interest: (productToShow! as! CreditType).rateShow, currency: (productToShow! as! CreditType).currencyName, isSelected: productToShow!.selected)
                break;
            case "calculo":
                cell.show(product: self.productType, type: "", interest: (productToShow! as! CalculatorType).name, currency: "", isSelected: productToShow!.selected)
                break;
            default:
                cell.show(product: self.productType, type: (productToShow! as! SavingType).typeName, interest: (productToShow! as! SavingType).interestShow, currency: (productToShow! as! SavingType).currencyTypeName, isSelected: productToShow!.selected)
                break;
        }
        cell.btnCheckBox.tag = indexPath.row
        return cell
    }
    
}
