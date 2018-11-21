//
//  SelectFromAccountCell.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno on 31/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class SelectFromAccountCell: UITableViewCell {

    @IBOutlet weak var lblAvailableBalance: UILabel!
    @IBOutlet weak var lblTypeDescription: UILabel!
    @IBOutlet weak var lblSinpe: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAliasName: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblPaymentDesc: UILabel!
    @IBOutlet weak var lblAliasNameHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblSinpeHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnCheckBox.layer.backgroundColor = UIColor.white.cgColor
        self.btnCheckBox.layer.borderWidth = 1
        self.btnCheckBox.layer.borderColor = UIColor(red:0.84, green:0.93, blue:0.93, alpha:1.0).cgColor
        self.btnCheckBox.layer.cornerRadius = 12.5
    }
  
    func showPayCreditType(_ item: PayCreditType){
        self.lblAliasNameHeight.constant = 6
        self.lblAliasName.layoutIfNeeded()
        self.lblName.font = UIFont.boldSystemFont(ofSize: 15)
        self.lblName.textColor = UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0)
        self.show("", owner: item.name as String, alias: "",
                  longAccountNumber: "", amount: "", paymentDesc: "", isSelected: item.selected)
    }
    
    func showCreditType(_ item: CreditByType){
        self.lblAliasNameHeight.constant = 6
        self.lblAliasName.layoutIfNeeded()
        self.lblName.font = UIFont.boldSystemFont(ofSize: 15)
        self.lblName.textColor = UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0)
        self.show("", owner: item.alias as String, alias: "",
                  longAccountNumber: "", amount: "", paymentDesc: "", isSelected: item.selected)
    }
    
    func showAccount(_ item: Account, section: String, transactionType: String = ""){
        if section == "sinpeDesafiliacion" {
            //self.lblAliasNameHeight.constant = 0
            //self.lblAliasName.layoutIfNeeded()
            //self.lblName.font = UIFont.boldSystemFont(ofSize: 15)
            //self.lblName.textColor = UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0)
            //self.show("", owner: "Teléfono: " + Helper.formatPhone(text: item.phoneNumber.description), alias: "",
            //          longAccountNumber: "Cuenta IBAN " + item.iban.description, amount: "", paymentDesc: "", isSelected: item.selected)
            self.show("Teléfono: " + Helper.formatPhone(text: item.phoneNumber.description), owner: item.name.description, alias: item.aliasName.description,
                      longAccountNumber: "Cuenta IBAN " + item.iban.description, amount: "", paymentDesc: "", isSelected: item.selected)
        }
        else{
            if section == "transaccionDestino" {
                if (transactionType.description.range(of:"1") == nil){
                    self.lblTypeHeight.constant = 7
                    self.lblTypeDescription.layoutIfNeeded()
                }
                self.show((transactionType.description.range(of:"1") != nil) ? item.typeDescription.description : "", owner: item.name as String, alias: item.aliasName as String,
                          longAccountNumber: "Cuenta IBAN " + (item.iban as String), amount: "",
                          paymentDesc: "", isSelected: item.selected, section: section, phone: item.currencyTypeId.description)
            }
            else{
                self.show(item.typeDescription as String, owner: item.name as String, alias: item.aliasName as String,
                          longAccountNumber: "Cuenta IBAN " + (item.iban as String), amount: Helper.formatAmount(item.availableBalance, currencySign: item.currencySign as String),
                          paymentDesc: "Saldo Actual", isSelected: item.selected, section: section, phone: item.phoneNumber.description)
            }
        }
    }
    
    fileprivate func show(_ accountDescription: String, owner: String, alias: String, longAccountNumber: String, amount: String, paymentDesc: String, isSelected: Bool, section: String = "", phone: String = ""){
        self.lblTypeDescription.text = accountDescription
        self.lblName.text = owner
        self.lblSinpe.text = longAccountNumber
        if section == "sinpeTransaction" {
            if longAccountNumber.count < 13 {
                self.lblSinpeHeight.constant = 0
                self.lblSinpe.layoutIfNeeded()
            }
            self.lblPhoneNumber.text = (phone.isEmpty) ? "" : "Teléfono: " + Helper.formatPhone(text: phone)
        }
        if section == "transaccionDestino"{
            lblPhoneNumber.font = UIFont.systemFont(ofSize: 12)
            lblPhoneNumber.textColor = UIColor.black
            lblPhoneNumber.text = phone
        }
        self.lblAliasName.text = alias
        if longAccountNumber == "" {
            self.lblAliasName.font = UIFont.systemFont(ofSize: 12)
        }
        self.lblAvailableBalance.text = amount
        self.lblPaymentDesc.text = paymentDesc
        if isSelected {
            self.btnCheckBox.layer.backgroundColor = UIColor(red:0.00, green:0.58, blue:0.56, alpha:1.0).cgColor
        }
        else{
            self.btnCheckBox.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
}
