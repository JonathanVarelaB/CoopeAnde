//
//  CreditDetailViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/14/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class CreditDetailViewController: BaseViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTitleScreen: UILabel!
    @IBOutlet weak var lblAliasCredit: UILabel!
    @IBOutlet weak var lblDescCredit: UILabel!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var lblOperation: UILabel!
    @IBOutlet weak var lblTotalQuota: UILabel!
    @IBOutlet weak var lblInterest: UILabel!
    @IBOutlet weak var lblPolicy: UILabel!
    @IBOutlet weak var lblPendingQuota: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAmountQuota: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var loadDate: UIProgressView!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var btnMovements: UIButton!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var viewAmountQuota: UIView!
    @IBOutlet weak var viewDate: UIView!
    
    var logo : UIImage?
    var titleScreen: String = ""
    var alias: String = ""
    var desc: String = ""
    var owner: String = ""
    var operation: String = ""
    var iban: String = ""
    var totalQuota: String = ""
    var interest: String = ""
    var policy: String = ""
    var pendingQuota: String = ""
    var amount: String = ""
    var amountQuota: String = ""
    var date: String = ""
    var currency: String = ""
    var days: String = ""
    var progressDate: Float = 0
    var colorProgressDate: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDesign()
        self.title = "Créditos"
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
        self.imgLogo.image = self.logo
        self.lblTitleScreen.text = self.titleScreen
        self.lblAliasCredit.text = self.alias
        self.lblDescCredit.text = self.desc
        self.lblOwner.text = self.owner
        self.lblOperation.text = self.iban
        self.lblTotalQuota.text = self.totalQuota
        self.lblInterest.text = self.interest
        self.lblPolicy.text = self.policy
        self.lblPendingQuota.text = self.pendingQuota
        self.lblAmount.text = self.amount
        self.lblAmountQuota.text = self.amountQuota
        self.lblDate.text = self.date
        self.lblDays.text = self.days
        if self.colorProgressDate == 1 {
            self.loadDate.progressTintColor = UIColor.red
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0) {
            self.loadDate.setProgress(self.progressDate, animated: true)
        }
    }
    
    func setDesign(){
        self.btnPay.layer.cornerRadius = 4
        self.btnMovements.layer.cornerRadius = 4
        let border1 = CALayer()
        border1.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        border1.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 1)
        border1.borderWidth = 1
        let border2 = CALayer()
        border2.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        border2.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 1)
        border2.borderWidth = 1
        let border3 = CALayer()
        border3.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        border3.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 1)
        border3.borderWidth = 1
        let border4 = CALayer()
        border4.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        border4.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 1)
        border4.borderWidth = 1
        self.viewDetails.layer.addSublayer(border1)
        self.viewDetails.layer.masksToBounds = true
        self.viewAmount.layer.addSublayer(border2)
        self.viewAmount.layer.masksToBounds = true
        self.viewAmountQuota.layer.addSublayer(border3)
        self.viewAmountQuota.layer.masksToBounds = true
        self.viewDate.layer.addSublayer(border4)
        self.viewDate.layer.masksToBounds = true
    }
    
    @objc func returnBack(sender: UIBarButtonItem) {
        self.backAction()
    }
    
    func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openMovements(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreditMovementsViewController") as! CreditMovementsViewController
        vc.actualAmount = self.lblAmount.text!
        vc.alias = self.lblAliasCredit.text!
        vc.subTitle = "Saldo Actual"
        vc.type = self.lblDescCredit.text!
        vc.owner = "Deudor: " + self.lblOwner.text!
        vc.operation = self.operation
        vc.iban = self.iban
        vc.currency = self.currency
        vc.sectionType = 0
        self.show(vc, sender: nil)
    }

    @IBAction func pay(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "PayCreditDetailViewController") as? PayCreditDetailViewController
        vc?.logo = self.logo
        vc?.titleCredit = self.titleScreen
        vc?.idProduct = self.operation
        vc?.aliasProduct = self.alias
        vc?.creditType = self.desc
        vc?.operation = self.operation
        vc?.mainViewController = self
        self.show(vc!, sender: nil)
    }
    
}
