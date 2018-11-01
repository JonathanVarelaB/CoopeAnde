//
//  CreditDetailViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/14/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class CreditDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

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
    @IBOutlet weak var typeTableView: UITableView!
    @IBOutlet weak var viewScroll: UIScrollView!
    @IBOutlet weak var viewButton: UIView!
    
    var logo: UIImage?
    var titleScreen: String = ""
    var operation: String = ""
    var iban: String = ""
    var currency: String = ""
    var progressDate: Float = 0
    var colorProgressDate: Int = 0
    var credits: Array<CreditByType> = []
    var creditSelected: CreditByType! = nil
    var borderHeader: CALayer = CALayer()
    var borderAmount: CALayer = CALayer()
    var borderAmountQuota: CALayer = CALayer()
    var borderDate: CALayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewScroll.isHidden = true
        self.viewButton.isHidden = true
        self.typeTableView.tableFooterView = UIView()
        self.setDesign()
        self.title = "Créditos"
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
        self.imgLogo.image = self.logo
        self.lblTitleScreen.text = self.titleScreen
        if self.credits.count == 1 {
            self.assignProductSelect(product: self.credits[0], type: "")
            self.creditSelected.selected = true
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
        self.borderHeader.removeFromSuperlayer()
        self.borderHeader = CALayer()
        self.borderHeader.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.borderHeader.frame = CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width - 30, height: 0.7)
        self.borderHeader.borderWidth = 1
        self.borderAmount.removeFromSuperlayer()
        self.borderAmount = CALayer()
        self.borderAmount.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.borderAmount.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 0.7)
        self.borderAmount.borderWidth = 1
        self.borderAmountQuota.removeFromSuperlayer()
        self.borderAmountQuota = CALayer()
        self.borderAmountQuota.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.borderAmountQuota.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 0.7)
        self.borderAmountQuota.borderWidth = 1
        self.borderDate.removeFromSuperlayer()
        self.borderDate = CALayer()
        self.borderDate.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.borderDate.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 0.7)
        self.borderDate.borderWidth = 1
        self.viewAmount.layer.addSublayer(self.borderAmount)
        self.viewAmount.layer.masksToBounds = true
        self.viewAmountQuota.layer.addSublayer(self.borderAmountQuota)
        self.viewAmountQuota.layer.masksToBounds = true
        self.viewDate.layer.addSublayer(self.borderDate)
        self.viewDate.layer.masksToBounds = true
        self.typeTableView.layer.addSublayer(self.borderHeader)
        self.typeTableView.layer.masksToBounds = true
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectAccountServiceViewController") as! SelectAccountServiceViewController
        vc.products = self.credits
        vc.detailServiceViewController = self
        vc.productSelected = self.creditSelected
        vc.productType = "credito"
        vc.sectionType = "pagoCredito"
        vc.titleTypeCredit = self.titleScreen
        self.show(vc, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80.0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async() {
            self.setDesign()
            if self.typeTableView != nil {
                self.typeTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.typeTableView.separatorStyle = .singleLine
        self.typeTableView.separatorColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3)
        self.typeTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        let cell = self.typeTableView.dequeueReusableCell(withIdentifier: "PhoneAffiliateCell", for: indexPath) as! PhoneAffiliateCell
        if self.creditSelected != nil {
            cell.show(select: "", phoneNumber: self.creditSelected.alias, credit: true)
        }
        else{
            cell.show(select: "Seleccione el crédito", phoneNumber: "")
        }
        return cell
    }
    
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
            self.colorProgressDate = 0
            return "En " + days.description + " día(s)"
        }
        else{
            if days == 0{
                self.colorProgressDate = 0
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
    
    override func cleanProductSelect(type: String) {
        self.creditSelected = nil
        self.typeTableView.reloadData()
        self.viewScroll.isHidden = true
        self.viewButton.isHidden = true
    }
    
    override func assignProductSelect(product: SelectableProduct, type: String) {
        self.creditSelected = (product as! CreditByType)
        self.setInfo()
        self.typeTableView.reloadData()
        self.viewScroll.isHidden = false
        self.viewButton.isHidden = false
    }
    
    func setInfo(){
        self.lblDescCredit.text = self.creditSelected.description
        self.lblOwner.text = self.creditSelected.owner
        self.lblOperation.text = self.creditSelected.iban
        self.operation = self.creditSelected.operation
        self.iban = self.creditSelected.iban
        self.lblTotalQuota.text = self.creditSelected.totalQuota.description + " meses"
        self.lblInterest.text = Helper.formatAmount(self.creditSelected.interests) + "%"
        self.lblPolicy.text = self.creditSelected.pendingPolicy.description
        self.lblPendingQuota.text = self.creditSelected.pendingQuota.description
        self.lblAmount.text = Helper.formatAmount(self.creditSelected.balanceAmount, currencySign: self.creditSelected.currencySign)
        self.lblAmountQuota.text = Helper.formatAmount(self.creditSelected.quotaAmount, currencySign: self.creditSelected.currencySign)
        self.lblDate.text = self.paymentDate(date: self.creditSelected.maxPaymentDate!)
        self.lblDays.text = self.calculateDays(date: self.creditSelected.maxPaymentDate!)
        self.currency = self.creditSelected.currencySign
        if self.creditSelected.maxPaymentDate != nil {
            if self.creditSelected.cutOffDate != nil {
                self.progressDate = self.calculateProgressDate(minDate: self.creditSelected.cutOffDate!, maxDate: self.creditSelected.maxPaymentDate!)
                    self.loadDate.progressTintColor = (self.colorProgressDate == 1) ? UIColor.red : UIColor.blue
            }
        }
    }
    
    @IBAction func openMovements(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreditMovementsViewController") as! CreditMovementsViewController
        vc.actualAmount = self.lblAmount.text!
        vc.alias = self.creditSelected.alias
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
        vc?.aliasProduct = self.creditSelected.alias
        vc?.creditType = self.lblDescCredit.text!
        vc?.operation = self.operation
        vc?.mainViewController = self
        self.show(vc!, sender: nil)
    }
    
}
